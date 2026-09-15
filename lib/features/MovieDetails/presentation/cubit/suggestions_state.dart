import '../../model/suggestions_model.dart';

abstract class SuggestionsState {}
 class SuggestInital extends SuggestionsState{}
class SuggestionsLoading extends SuggestionsState {}
class SuggestionsLoaded extends SuggestionsState {
  final List<SuggestedMovieModel> suggestionMovies;
  SuggestionsLoaded({required this.suggestionMovies});
}
class SuggestionsFailure extends SuggestionsState {
  final String msg;
  SuggestionsFailure({required this.msg});
}
