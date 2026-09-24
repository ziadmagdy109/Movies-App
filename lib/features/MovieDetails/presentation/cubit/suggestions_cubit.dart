import 'package:bloc/bloc.dart';
import 'package:movies_app/features/MovieDetails/presentation/cubit/suggestions_state.dart';

import '../../repo/movie_details_repo.dart';
class SuggestionsCubit extends Cubit<SuggestionsState> {
  final MovieDetailsRepo movieDetailsRepository;

  SuggestionsCubit({required this.movieDetailsRepository}) : super(SuggestInital());

  Future<void> getSuggestions(int movieId) async {
    emit(SuggestionsLoading());
    try {
      final movieDetailsList = await movieDetailsRepository.getMovieSuggestions(movieId);
      if (isClosed) return;
      emit(SuggestionsLoaded(suggestionMovies: movieDetailsList));
    } catch (e) {
      if (isClosed) return;
      emit(SuggestionsFailure(msg: e.toString()));
    }
  }
}