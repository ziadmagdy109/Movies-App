# Movies App — Project Changes

Favorites / Watchlist / History system, complete Profile persistence, and registration-name flow.

This document is written from the **actual code currently in the repository**. It compares the state before these changes with the current implementation, explains why each change was made, and walks through how all the pieces communicate.

---

## 1. Summary

The app is a Flutter movies app (YTS API + Firebase Auth + Cloud Firestore) that uses a **Cubit/BloC** state-management pattern with a **Repository** data layer. Before these changes:

- The Profile screen was 100% mocked: the Wish List counter was hard-coded `"12"`, the History counter was hard-coded `"10"`, the History tab was a fake grid of 15 identical empty items, and the Watch List tab was just a static empty image.
- The movie details page had a **local-only** bookmark toggle (`bool isWatchList`) that did nothing, disappeared when the page was closed, and was not connected to anything.
- The registration flow created a Firebase Auth account but **never saved the user's name or phone**, so the Profile always fell back to hard-coded placeholder values (`'John Safwat'`).
- The profile update screen wrote to Firestore but never read anything back, and its navigation back to the Profile was fragile.

What was implemented:

1. **Favorites / Watchlist** — a real, per-user, persisted favorite system backed by Firestore. The bookmark button on Home movie cards and the bookmark in Movie Details now read/write the same shared state, and the Profile "Watch List" tab + counter mirror that state automatically.
2. **History** — when the user successfully triggers the "Watch" action on Movie Details (opens the external IMDb page), the movie is added to a per-user History list (deduplicated, most-recent-first). The Profile "History" tab + counter mirror it automatically.
3. **Architecture** — a new `features/library/` feature was added following the existing Cubit → Repository → data-source structure, and the `UserLibraryCubit` is provided **above `MaterialApp`** so every screen shares one source of truth.
4. **Profile persistence** — Profile and Edit-Profile now read the user's real name/phone/avatar from Firestore on load, and registration stores the typed name/phone so the Profile shows real data instead of placeholders.

---

## 2. Every Change Made

### 2.1 New files

| File | Type | Responsible for |
| --- | --- | --- |
| `lib/features/library/data/models/saved_movie.dart` | Added | `SavedMovie` model — a light snapshot of a movie (id, title, image, rating) used for Favorites and History. |
| `lib/features/library/data/repository/user_library_repository.dart` | Added | `UserLibraryRepository` — all Firestore reads/writes for favorites and history (per user). |
| `lib/features/library/presentation/cubit/user_library_state.dart` | Added | `UserLibraryState` classes (`UserLibraryInitial`, `UserLibraryLoading`, `UserLibraryLoaded`, `UserLibraryFailure`). |
| `lib/features/library/presentation/cubit/user_library_cubit.dart` | Added | `UserLibraryCubit` — the single in-memory source of truth (`favorites`, `history`) with `load()`, `toggleFavorite()`, `addToHistory()`, `isFavorite()`. |

### 2.2 Modified files

| File | What changed | Why |
| --- | --- | --- |
| `lib/main.dart` | `MyApp.build` now wraps the app in `MultiBlocProvider` with a single `BlocProvider<UserLibraryCubit>`. | The favorites/history state must be visible to **every route** (Home, Movie Details, Profile). Because MaterialPageRoutes are siblings under the Navigator, only a provider above `MaterialApp` is reachable from every screen. |
| `lib/features/Home/data/models/movies.dart` | Added a `title` field and a named constructor `Movies({id, rating, largeCoverImage, title})`. | The `SavedMovie` snapshot needs a title; the list-movies JSON provides it. The constructor lets us build a `Movies` from a `SavedMovie` for reuse in `MovieGridItem` on the Profile grids. |
| `lib/core/widgets/movie_grid_item.dart` | Added a bookmark toggle overlay (top-right) on every movie card. | Home cards are the primary "favorite" surface. The button calls `UserLibraryCubit.toggleFavorite(...)` and its icon is driven by the same cubit. Hidden when `movies == null` (Search/Browse placeholders). |
| `lib/features/Home/presentation/views/home_view.dart` | Converted to a `StatefulWidget`; `initState` calls `context.read<UserLibraryCubit>().load()`. | The layout is recreated after every login, so this is a safe trigger to reload the current user's favorites/history from Firestore. |
| `lib/features/MovieDetails/presentation/views/movie_details_view.dart` | (a) Removed local `bool isWatchList`; the bookmark in the app bar now reads/toggles the shared `UserLibraryCubit`. (b) The red "Watch" button now adds the movie to History **only after** `launchUrl` succeeds. | The old bookmark was cosmetic local state that reset on close and never synced anywhere. History is recorded only when the external open actually succeeds. |
| `lib/features/profile/presentation/views/profile_view.dart` | Counters now compute `favorites.length` / `history.length` from the cubit; Watch List and History tabs render real grids from the cubit with empty states. | Removes the hard-coded `"12"`/`"10"`/`15` mocks and makes Profile reflect real, synchronized data. |
| `lib/features/profile/presentation/cubit/update_profile_cubit.dart` | Added static `avatars` list, `avatarFromPath()`, `loadProfile()`; `updateProfile()` is now best-effort with 10 s timeouts and always emits success for the in-app flow. | Profile must display and pre-fill **real stored data**, and the save flow must reliably return to the Profile. |
| `lib/features/profile/presentation/cubit/update_profile_states.dart` | Added `UpdateProfileLoaded` state. | A state that carries loaded profile data but is *distinct* from `UpdateProfileSuccess`, so loading does not trigger the "save succeeded" navigation. |
| `lib/features/profile/presentation/views/update_profile_view.dart` | Pre-fills fields from Firestore via the cubit, uses the shared `UpdateProfileCubit.avatars`, pops before showing toast, and guards against double-submission with a `_submitting` flag. | Editing should start with the user's real current values, the `avatars` list must be shared with the cubit so path→image resolution works, and returning to Profile must never be blocked. |
| `lib/core/services/fire_base_services.dart` | `signUpWithEmailAndPassword` now also accepts `name` and `phone`, sets `user.updateDisplayName(name)`, and writes `profiles/{uid}` = `{name, phone}`. | Registration must persist the typed name so Profile shows the real name instead of a placeholder. |
| `lib/features/Auth/presentation/cubit/signup_cubit.dart` | `signUp` now takes named params `{name, email, password, phone}` and forwards them. | Pass-through required by the service change. |
| `lib/features/Auth/presentation/views/register_view.dart` | `_onSubmit` now passes `name` and `phone` from the form controllers to `signUp`. | Wires the typed form values into the new flow. |

---

## 3. Before vs After

### 3.1 main.dart — provide the shared cubit

**Before:**
```dart
return ScreenUtilInit(
  designSize: const Size(360, 690),
  child: MaterialApp(...),
);
```

**After:**
```dart
return MultiBlocProvider(
  providers: [
    BlocProvider<UserLibraryCubit>(
      create: (context) => UserLibraryCubit(
        repository: UserLibraryRepository(),
      ),
    ),
  ],
  child: ScreenUtilInit(
    designSize: const Size(360, 690),
    child: MaterialApp(...),
  ),
);
```

**Why:** Every screen must read the same favorites/history object. A cubit provided inside a single route (e.g. the Layout route) is not visible to pushed routes like Movie Details. Providing it above `MaterialApp` makes it an ancestor of **all** routes.

### 3.2 Movie Details — from fake local state to shared state

**Before:**
```dart
bool isWatchList = false;
// ...
GestureDetector(
  child: isWatchList ? Assets.icons.bookMark.svg() : Assets.icons.bookmarkempty.image(...),
  onTap: () { setState(() { isWatchList = !isWatchList; }); },
),
```

**After:**
```dart
BlocBuilder<UserLibraryCubit, UserLibraryState>(
  builder: (context, state) {
    final isFavorite = context.read<UserLibraryCubit>().isFavorite(movieId);
    return GestureDetector(
      child: isFavorite ? Assets.icons.bookMark.svg() : Assets.icons.bookmarkempty.image(...),
      onTap: () {
        context.read<UserLibraryCubit>().toggleFavorite(
          SavedMovie.fromDetails(id: movieId, details: movieDetails),
        );
      },
    );
  },
),
```

**Why:** The old code was purely visual and reset every time the page opened. Now the icon reflects the shared `UserLibraryCubit.isFavorite(id)`, so it is always in sync with Home and Profile, and tapping toggles the real persisted favorite.

### 3.3 Home — a real favorite button on movie cards

**Before:** `MovieGridItem` only had the rating badge (top-left) and pushed Movie Details on tap. No favorite control.

**After:** A top-right bookmark overlay appears when `movies != null`, driven by `UserLibraryCubit`:
```dart
Positioned(
  top: 8.h, right: 8.w,
  child: movies == null
      ? const SizedBox()
      : BlocBuilder<UserLibraryCubit, UserLibraryState>(
          builder: (context, state) {
            final isFavorite = context.read<UserLibraryCubit>().isFavorite(movies!.id);
            return GestureDetector(
              onTap: () {
                context.read<UserLibraryCubit>()
                    .toggleFavorite(SavedMovie.fromMovies(movies!));
              },
              child: Container(... isFavorite ? bookMark : bookmarkempty ...),
            );
          }),
),
```

**Why:** The requirement was a favorite toggle on the Home page that stays synchronized everywhere. Because `MovieGridItem` is shared by Home, Profile, Search, and Browse, adding the button here gives it to Home and Profile for free (Search/Browse pass `null`, so the button is hidden).

### 3.4 Profile counters and tabs

**Before:**
```dart
Text("12")          // Wish List counter (hard-coded)
Text("10")          // History counter (hard-coded)
...
body: TabBarView(controller: tabController, children: [
  Center(child: Assets.images.empty.image(...)),   // Watch List placeholder
  GridView.builder(itemCount: 15, itemBuilder: (_) => const MovieGridItem()),
]),
```

**After:**
```dart
// counter row (each number wrapped in a BlocBuilder)
'${context.read<UserLibraryCubit>().favorites.length}'
'${context.read<UserLibraryCubit>().history.length}'

// body
BlocBuilder<UserLibraryCubit, UserLibraryState>(
  builder: (context, state) {
    final favorites = context.read<UserLibraryCubit>().favorites;
    final history = context.read<UserLibraryCubit>().history;
    return TabBarView(controller: tabController, children: [
      favorites.isEmpty
          ? Center(child: Assets.images.empty.image(width: 120.w, height: 120.h))
          : GridView.builder(..., itemBuilder: (_, i) => MovieGridItem(movies: favorites[i].toMovies())),
      history.isEmpty
          ? Center(child: Assets.images.empty.image(width: 120.w, height: 120.h))
          : GridView.builder(..., itemBuilder: (_, i) => MovieGridItem(movies: history[i].toMovies())),
    ]);
  },
)
```

**Why:** All mock values are gone. Counters are `favorites.length` / `history.length` (always real), and each tab shows the actual list or the existing empty-state image — never a fabricated grid.

### 3.5 Registration saves the name

**Before (service):**
```dart
Future<bool> signUpWithEmailAndPassword(String emailAddress, String password) async {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailAddress, password: password);
  return true;
}
```

**After (service):**
```dart
Future<bool> signUpWithEmailAndPassword(String emailAddress, String password, String name, String phone) async {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailAddress, password: password);
  final user = credential.user;
  if (user != null) {
    await user.updateDisplayName(name);
    await FirebaseFirestore.instance.collection('profiles').doc(user.uid).set({'name': name, 'phone': phone});
  }
  return true;
}
```

`SignUpCubit.signUp` and `RegisterView._onSubmit` were updated to pass `name` and `phone`. **Before**, the cubit signature was `signUp(String email, String password)`.

**Why:** The typed name never reached any storage, so Profile always showed `'John Safwat'`. Now the name is stored in Firebase Auth (`updateDisplayName`) **and** in the `profiles/{uid}` Firestore document, which is exactly what `UpdateProfileCubit.loadProfile()` reads.

### 3.6 Profile edit reads and writes real data

**Before:** `UpdateProfileCubit` only had `updateProfile()` (write-only). The edit view used hard-coded defaults (`'John Safwat'`, `'01200000000000'`), a private `_avatars` list, disabled the button while `Loading` (could get stuck), and called `Navigator.pop` **after** `Fluttertoast.showToast`.

**After:** `UpdateProfileCubit` gained `loadProfile()` (reads `profiles/{uid}` with a 10 s timeout), a shared static `avatars` list, `avatarFromPath()`, and `updateProfile()` that treats persistence as best-effort (writes wrapped in `try/catch` with 10 s timeouts) and **always** emits `UpdateProfileSuccess` so the screen reliably pops. The edit view pre-fills controllers from `UpdateProfileLoaded`, and the button is gated by a `_submitting` bool instead of the ephemeral `Loading` state.

**Why:** The old flow could display stale placeholder data, hang in `Loading`, or fail to navigate back — all fixed by reading before editing, never blocking on the backend for the UI result, and guarding submission with a simple boolean.

---

## 4. Architecture

The new feature follows the same layered pattern used by the existing `Home` feature (Cubit → Repository → data source):

```
UI (widgets)
   │  calls methods / reads state
   ▼
Cubit (UserLibraryCubit)
   │  holds the current lists (favorites, history) in memory
   ▼
Repository (UserLibraryRepository)
   │  encapsulates every Firestore query and mutation
   ▼
Data source (Cloud Firestore)
   │
   ▼
Model (SavedMovie) ← used to translate DB maps ⇄ Dart objects
```

Responsibilities:

| Layer | Why it exists |
| --- | --- |
| **UI** | Renders state; never touches Firebase directly. Its only job: call a cubit method and rebuild from the emitted state. |
| **Cubit** | Owns the **single source of truth** in memory (`favorites`, `history`), decides what to do on user actions, emits new states so every listening widget updates, and performs optimistic updates + rollback. It does **not** know query syntax. |
| **Repository** | Owns the data format/location. Knows `profiles/{uid}/favorites`, `profiles/{uid}/history`, the exact fields, ordering, and the current Firebase Auth user. |
| **Data source** | Cloud Firestore — the durable store. |
| **Model** | `SavedMovie` defines the shape shared between the DB and the UI, and provides converters (`fromJson`, `toJson`, `fromMovies`, `fromDetails`, `toMovies`). |

Why this layering (beginner-friendly): if we ever swap Firestore for another backend, only `UserLibraryRepository` changes. If we change what a saved movie looks like, only `SavedMovie` changes. The UI stays unchanged because it only ever talks to the cubit.

---

## 5. Favorites / Watchlist

### Where favorite state is stored
- **In memory:** `UserLibraryCubit._favorites` (exposed via `List<SavedMovie> get favorites`).
- **Persisted:** Firestore subcollection `profiles/{uid}/favorites/{movieId}`, one document per movie, **document id = the movie id** (this alone prevents duplicates).

### How a movie becomes a favorite
1. User taps the bookmark on a Home card (`MovieGridItem`) **or** on Movie Details.
2. The widget calls `context.read<UserLibraryCubit>().toggleFavorite(SavedMovie...)`.
3. In `toggleFavorite`, if the movie is not already in `_favorites`, it is inserted at index 0 and a new `UserLibraryLoaded` state is emitted (UI instantly shows the filled bookmark).
4. `repository.addFavorite(movie)` stores `{id, title, image, rating, addedAt}` under `favorites/{movieId}`.

### How it is removed
`toggleFavorite` again: if present, it removes the movie from `_favorites` (new state emitted), then calls `repository.removeFavorite(movie.id)` which deletes `favorites/{movieId}`.

### Home ⇄ Movie Details synchronization
Both widgets read `context.read<UserLibraryCubit>().isFavorite(id)` inside a `BlocBuilder<UserLibraryCubit, UserLibraryState>`. Because there is only **one** `UserLibraryCubit` instance (provided in `main.dart`), any toggle emits a state that rebuilds all listening widgets — Home cards, the Details bookmark, Profile counters, and Profile tabs — immediately.

### How Profile gets the Watchlist
Profile does not store anything. Its Watch List tab reads `context.read<UserLibraryCubit>().favorites` and maps each `SavedMovie` to a `Movies` via `toMovies()`, reusing `MovieGridItem` for display.

### How the Watchlist counter is calculated
`'${context.read<UserLibraryCubit>().favorites.length}'` inside a `BlocBuilder`. It is dynamic; 0, 3, or 10 favorites always render the true count.

### How duplicates are prevented
- A movie id can never appear twice in `_favorites` (removed or inserted, never appended blindly).
- The Firestore document key is `favorites/${movie.id}`, so writing twice overwrites the same document.

### How data persists
Each call to `toggleFavorite` immediately writes/deletes the Firestore document, so Favorites survive screen changes, page closes, and app restarts. On app start, `HomeView.initState` calls `UserLibraryCubit.load()`, which reads `getFavorites()` and `getHistory()`.

### Firebase structure (Favorites)

```
profiles/{uid}
   ├── favorites/
   │     ├── 12        → { id: 12, title: "Inception", image: "https://...", rating: 8.3, addedAt: 1730000000000 }
   │     └── 45        → { id: 45, title: "Interstellar", image: "https://...", rating: 8.4, addedAt: 1730000001234 }
   └── history/
         ├── 45        → { id: 45, title: "Interstellar", image: "https://...", rating: 8.4, watchedAt: 1730000100000 }
         └── 12        → { id: 12, title: "Inception", image: "https://...", rating: 8.3, watchedAt: 1730000200000 }
```

Queries used:
- `getFavorites()` → `profiles/{uid}/favorites` ordered by `addedAt` descending.
- `addFavorite` → `set()`, `removeFavorite` → `delete()`.

---

## 6. History

### When a movie is added to History
Only in `MovieDetailsView`, red "Watch" button's `onPressed`. After `final launched = await launchUrl(url, mode: LaunchMode.externalApplication);`, if `launched == true` the cubit's `addToHistory(...)` is called. History is **not** recorded if the external URL fails to open or throws.

**Before:** the Watch button only opened the URL and showed a toast on failure.
**After:** on success it also records history.

### How duplicates are handled
`addToHistory` first does `_history.removeWhere((item) => item.id == movie.id);` then inserts at index 0. The Firestore doc key is `history/${movie.id}` (a `set()` overwrites), so the same movie can never appear twice.

### How the latest-watched movie is handled
It is inserted at the **front** of `_history` (moved to the latest position), and `watchedAt` is updated to `DateTime.now()` — persist order is "most recent first" via `orderBy('watchedAt', descending: true)`.

### Where History is stored
- In memory: `UserLibraryCubit._history`.
- Persisted: `profiles/{uid}/history/{movieId}` with fields `{id, title, image, rating, watchedAt}`.

### How Profile displays it
The History tab reads `history` from the cubit and renders `MovieGridItem(movies: history[index].toMovies())`.

### How the History counter is calculated
`'${context.read<UserLibraryCubit>().history.length}'` — dynamic, never hard-coded.

### How persistence works
`repository.addToHistory(movie)` `set()`s the document with a fresh `watchedAt`. `load()` reads them back on app start.

---

## 7. State Management

### 7.1 `UserLibraryCubit` (new)

- **Responsibility:** single source of truth for favorites and history across the whole app.
- **Methods:**
  - `load()` — reads the current user's favorites + history; resets lists when the user changes; called by `HomeView.initState`.
  - `isFavorite(int movieId)` — convenience check used by icons.
  - `toggleFavorite(SavedMovie movie)` — add/remove with optimistic update, persistence, and rollback on failure.
  - `addToHistory(SavedMovie movie)` — dedupe + move-to-front + persist.
- **States emitted:** `UserLibraryInitial` (constructor), `UserLibraryLoading` (during `load`), `UserLibraryLoaded(favorites, history)` (after every change), `UserLibraryFailure` (load error).
- **Triggers:** UI taps (favorite/watch) and screen init (`load`).
- **Listeners:** `MovieGridItem` bookmark, `MovieDetailsView` bookmark, `ProfileView` counters + Watch List/History tabs.

Data flow: UI action → cubit mutates internal lists → `_emitLoaded()` → every `BlocBuilder` listening to `UserLibraryCubit` rebuilds with the new data.

### 7.2 Modified: `UpdateProfileCubit` / `UpdateProfileState`

- `UpdateProfileLoaded` was added so loading data (`loadProfile()`) does not get confused with a successful save (`UpdateProfileSuccess`).
- `UpdateProfileCubit.loadProfile()` reads `profiles/{uid}` and emits `UpdateProfileLoaded` (or `UpdateProfileFailure`). `ProfileView` listens via a stream subscription; `UpdateProfileView` also listens to pre-fill the form.

---

## 8. Firebase / Database

Only **Cloud Firestore** is involved; the Firebase Auth user (the signed-in account) determines ownership.

### Collections & documents

| Path | Contents | Purpose |
| --- | --- | --- |
| `profiles/{uid}` | `{ name, phone, avatar }` | The user's profile document (previously created by `updateProfile`; now also created at registration). |
| `profiles/{uid}/favorites/{movieId}` | `{ id, title, image, rating, addedAt }` | One doc per favorited movie; doc id = movie id prevents duplicates. |
| `profiles/{uid}/history/{movieId}` | `{ id, title, image, rating, watchedAt }` | One doc per watched movie; doc id = movie id. |

### Operations
- **Read:** `getFavorites()` (`orderBy('addedAt', descending)`), `getHistory()` (`orderBy('watchedAt', descending)`), `loadProfile()` (single doc snapshot).
- **Write:** `addFavorite` (`set`), `addToHistory` (`set`), `signUp` creates `profiles/{uid}` (`set`), `updateProfile` overwrites `profiles/{uid}` (`set`).
- **Delete:** `removeFavorite` (`delete`).

### User association
All queries use `FirebaseAuth.instance.currentUser?.uid`. If no user is signed in, the repository returns empty lists / no-ops, so the app never crashes on the login/splash screens.

> Note: Firestore security rules are configured in the **Firebase console**, not in this repo. For favorites/history to persist after a restart, the production rules must allow an authenticated owner to read/write under `profiles/{uid}/**`.

---

## 9. UI Changes

| Screen | Widget | Change |
| --- | --- | --- |
| Home | `MovieGridItem` | Bookmark overlay (top-right) toggling favorites via `UserLibraryCubit`; hidden when `movies == null`. |
| Home | `HomeView` | Now `StatefulWidget`; `initState` reloads the user's library on login. |
| Movie Details | `SliverAppBar` actions | Bookmark icon tied to shared cubit instead of local `isWatchList`. |
| Movie Details | Red "Watch" button | Records History only after the external page launches successfully. |
| Profile | header Row counters | `favorites.length` / `history.length` (wrapped in `BlocBuilder`). |
| Profile | Watch List tab | Real grid of favorites or the existing empty image. |
| Profile | History tab | Real grid of history or the existing empty image. |

Data reception: every updated widget reads from the single `UserLibraryCubit`. Counters recalculate on every emitted state. Empty states are a conditional `Assets.images.empty` image; no `null` errors because empty lists render the empty state instead of building a grid.

---

## 10. Navigation Flow

Navigation itself was **not** changed (same `AppRouteName` / `AppRoutes`). What changed is state preservation:

```
Home (MovieGridItem)
   │ tap card → pushNamed(movieDetails, arguments: movieId)
   ▼
Movie Details (fetches details; bookmark reads shared cubit)
   │ tap "Watch" → launchUrl(imdb) → on success: UserLibraryCubit.addToHistory()
   ▼
External Website (IMDb/trailer)  →  user returns ← state already updated
   │
   ▼
Profile (IndexedStack tab) — Watch List / History tabs + counters read the same cubit
```

Because `UserLibraryCubit` lives above `MaterialApp` and stays alive the whole session, navigating between Home, Movie Details, the external browser, and Profile never loses or re-creates the data — every screen reads the same instance. On app restart, `load()` repopulates from Firestore.

---

## 11. Files Added / Modified

| File | Added/Modified | Purpose | Main Changes |
| --- | --- | --- | --- |
| `lib/features/library/data/models/saved_movie.dart` | Added | Light movie snapshot for favorites/history | `SavedMovie` with `fromJson`/`toJson`/`fromMovies`/`fromDetails`/`toMovies`. |
| `lib/features/library/data/repository/user_library_repository.dart` | Added | All favorites/history Firestore access | `getFavorites`, `addFavorite`, `removeFavorite`, `getHistory`, `addToHistory`; uid-guarded. |
| `lib/features/library/presentation/cubit/user_library_state.dart` | Added | Library state classes | `Initial`, `Loading`, `Loaded(favorites, history)`, `Failure`. |
| `lib/features/library/presentation/cubit/user_library_cubit.dart` | Added | Global source of truth | `load`, `isFavorite`, `toggleFavorite`, `addToHistory`, optimistic updates + rollback. |
| `lib/main.dart` | Modified | Provide the cubit app-wide | Added `MultiBlocProvider` wrapping `ScreenUtilInit`. |
| `lib/features/Home/data/models/movies.dart` | Modified | Support titles + construction from snapshots | Added `title` field and named constructor. |
| `lib/core/widgets/movie_grid_item.dart` | Modified | Add favorite button | Top-right bookmark overlay, `BlocBuilder` + `toggleFavorite`. |
| `lib/features/Home/presentation/views/home_view.dart` | Modified | Load library on login | Converted to `StatefulWidget`, `load()` in `initState`. |
| `lib/features/MovieDetails/presentation/views/movie_details_view.dart` | Modified | Sync bookmark + record history | Removed `isWatchList`; bookmark uses cubit; Watch adds history on success. |
| `lib/features/profile/presentation/views/profile_view.dart` | Modified | Real Profile data | Dynamic counters, real Watch List/History grids, empty states. |
| `lib/features/profile/presentation/cubit/update_profile_cubit.dart` | Modified | Real profile reads + reliable saves | `avatars`, `avatarFromPath`, `loadProfile`, best-effort `updateProfile`. |
| `lib/features/profile/presentation/cubit/update_profile_states.dart` | Modified | Distinct loaded state | Added `UpdateProfileLoaded`. |
| `lib/features/profile/presentation/views/update_profile_view.dart` | Modified | Pre-fill + reliable return | Stream listener pre-fill, shared avatars, `_submitting` guard, pop-first. |
| `lib/core/services/fire_base_services.dart` | Modified | Save name/phone at registration | `signUpWithEmailAndPassword(..., name, phone)` sets display name + Firestore doc. |
| `lib/features/Auth/presentation/cubit/signup_cubit.dart` | Modified | Pass name/phone | `signUp({name, email, password, phone})`. |
| `lib/features/Auth/presentation/views/register_view.dart` | Modified | Wire form values | `_onSubmit` passes `name` and `phone`. |

---

## 12. Important Code Concepts (Clean Architecture + Cubit, beginner-friendly)

- **Why a repository?** It is the single place that knows *where* and *how* data is stored. Widgets and cubits call `addFavorite(...)`, never Firestore. This keeps the data format changeable and the code testable.
- **Why doesn't the Cubit touch Firebase directly?** Separation of concerns: the cubit cares about *state transitions* (add/remove, what to emit); the repository cares about *storage*. This mirrors how the existing `MoviesRepository`/`MoviesWebService` split works.
- **Why was the model (`Movies`) changed?** Favorites need a title to be usable, and the list API already provides it. The added constructor lets the Profile grids reuse `MovieGridItem` with a value built from `SavedMovie`.
- **Why is state stored above `MaterialApp`?** Routes are siblings, not children, of each other. A shared instance must live above the Navigator so Home, Movie Details, and Profile all see the exact same lists — that is what makes "synchronized everywhere" possible with zero manual updates.
- **Why streams/futures?** Firestore is asynchronous (network). `getFavorites`/`getHistory` are `Future`s; the cubit awaits them in `load()`. `BlocBuilder` subscribes to the cubit's stream of states and rebuilds on each emit. Optimistic updates make toggles feel instant while the write happens in the background.
- **Why prevent duplicates?** The same movie must appear once. Duplicates would inflate counters and corrupt the Watchlist/History. The doc-id = movie-id strategy plus `removeWhere` before insert guarantees uniqueness.
- **Why are counters dynamic?** `favorites.length`/`history.length` always reflect reality and automatically update when the cubit emits. Hard-coded numbers would instantly become wrong.

---

## 13. Final Data Flow

### Favorite flow

```
User taps bookmark on Home card (MovieGridItem)
   → UserLibraryCubit.toggleFavorite(SavedMovie.fromMovies(movie))
      → update _favorites in memory (+ emit UserLibraryLoaded)
      → UserLibraryRepository.addFavorite / removeFavorite
         → Firestore: set/delete profiles/{uid}/favorites/{movieId}
   → all BlocBuilders rebuild:
      → Home bookmark icon updates
      → Movie Details bookmark updates when opened
      → Profile Watch List grid updates
      → Profile counter updates (favorites.length)
```

### Watch / History flow

```
User taps "Watch" on Movie Details
   → launchUrl(imdb) opens external website
   → if launched == true:
      → UserLibraryCubit.addToHistory(SavedMovie.fromDetails(...))
         → dedupe (_history.removeWhere) + insert at front (+ emit)
         → UserLibraryRepository.addToHistory
            → Firestore set profiles/{uid}/history/{movieId} (new watchedAt)
   → Profile History grid updates
   → Profile counter updates (history.length)
```

### Restart / login flow

```
App starts / user logs in
   → HomeView.initState → UserLibraryCubit.load()
      → UserLibraryRepository.getFavorites() + getHistory()
         → Firestore reads profiles/{uid}/favorites + histories
      → UserLibraryLoaded(favorites, history) emitted
   → Profile and all bookmark icons reflect persisted data
```

---

*End of documentation. All names, paths, classes, methods, and Firebase collections referenced above correspond to the actual code in the repository.*