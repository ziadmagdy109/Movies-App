import 'package:dio/dio.dart';
import 'package:movies_app/core/utils/api_list.dart';

class BrowseWebService {
  late Dio dio;

  BrowseWebService() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiList.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    );

    dio = Dio(options);
  }

  Future<List<dynamic>> getMoviesByGenre(String genre) async {
    try {
      Response response = await dio.get(
        ApiList.listMovies,
        queryParameters: {'genre': genre},
      );
      return response.data["data"]["movies"] ?? [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}