import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://newsapi.org/',
      headers: {
        'Content-Type': 'application/json',
        'lang': 'en',
      },
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response?> getData(
      {required String url, Map<String, dynamic>? query, String? token}) async {
    try {
      dio.options.headers = {
        'Content-Type': 'application/json',
        'lang': 'en',
        'Authorization': token
      };
      return await dio.get(url, queryParameters: query).then((value) {
        //print(value.data);
        return value;
      }).catchError((error) {
        print(error.toString());
        return error;
      });
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  static Future<Response?> postData(
      {required String url,
      Map<String, dynamic>? query,
      required Map data,
      String? token}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': 'en',
      'Authorization': token
    };
    return await dio
        .post(
      url,
      queryParameters: query,
      data: data,
    )
        .then((value) {
      print(value.data);
      return value;
    });
  }

  static Future<Response?> putData(
      {required String url,
      Map<String, dynamic>? query,
      required Map<String, String> data,
      String? token}) async {
    try {
      dio.options.headers = {
        'Content-Type': 'application/json',
        'lang': 'en',
        'Authorization': token
      };
      return await dio
          .put(
        url,
        queryParameters: query,
        data: data,
      )
          .then((value) {
        print(value.data);
        return value;
      });
    } catch (e) {
      return null;
    }
  }
}
