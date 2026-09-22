import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:movies_app/features/Search/data/repository/search_repository.dart';
import 'package:movies_app/features/Search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepository;

  Timer? debounce;

  SearchCubit({required this.searchRepository}) : super(searchInitial());

  void onQueryChanged(String query) {
    debounce?.cancel();

    if (query.trim().isEmpty) {
      emit(searchInitial());
      return;
    }

    debounce = Timer(
      const Duration(milliseconds: 400),
      () => searchAll(query.trim()),
    );
  }

  Future<void> searchAll(String query) async {
    emit(searchLoading());

    try {
      final movies = await searchRepository.searchAllMovies(query);

      if (movies.isEmpty) {
        emit(searchEmpty());
      } else {
        emit(searchLoaded(movies: movies, query: query));
      }
    } catch (e) {
      emit(searchFailure(msg: e.toString()));
    }
  }

  @override
  Future<void> close() {
    debounce?.cancel();
    return super.close();
  }
}