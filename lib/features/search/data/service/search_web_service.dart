import 'package:dio/dio.dart';
import 'package:movies_app/core/utils/api_list.dart';

class SearchWebService {
  late Dio dio;

  SearchWebService() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiList.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    );

    dio = Dio(options);
  }

  Future<List<dynamic>> searchAllMovies(String query) async {
    try {
      Response response = await dio.get(
        ApiList.listMovies,
        queryParameters: {'query_term': query},
      );
      return response.data["data"]["movies"] ?? [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}