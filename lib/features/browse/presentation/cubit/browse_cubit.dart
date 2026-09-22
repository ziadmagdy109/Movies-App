import 'package:bloc/bloc.dart';
import 'package:movies_app/features/Browse/data/repository/browse_repository.dart';
import 'package:movies_app/features/Browse/presentation/cubit/browse_state.dart';

class BrowseCubit extends Cubit<BrowseState> {
  final BrowseRepository browseRepository;

  static const List<String> categories = [
    "Action",
    "Adventure",
    "Animation",
    "Biography",
  ];

  int currentCategoryIndex = 0;

  BrowseCubit({required this.browseRepository}) : super(browseInitial());

  Future<void> selectCategory(int index) async {
    if (index == currentCategoryIndex && state is browseLoaded) return;

    currentCategoryIndex = index;
    emit(browseLoading());

    try {
      final movies = await browseRepository.getMoviesByGenre(categories[index]);
      emit(browseLoaded(movies: movies, genre: categories[index]));
    } catch (e) {
      emit(browseFailure(msg: e.toString()));
    }
  }
}