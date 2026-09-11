import 'package:dio/dio.dart';
import 'package:movies_app/core/utils/api_list.dart';

class MoviesWebService {
  late Dio dio;
  MoviesWebService() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiList.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
    );

    dio = Dio(options);
  }

  Future<List<dynamic>> getAllMovies() async {
    try {
      Response response = await dio.get(ApiList.listMovies);
      print(response.data.toString());
      return response.data["data"]["movies"];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getMoviesByGenre(String genre) async {
    try {
      Response response = await dio.get(
        ApiList.listMovies,
        queryParameters: {'genre': genre},
      );
      print(response.data.toString());
      return response.data["data"]["movies"];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
