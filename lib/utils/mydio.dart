import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import '../models/api_resp.dart';
import '../presets/api_paths.dart';

ApiResp respNew = ApiResp(
  ok: false,
  rdata: null,
  msgs: [], message: '',
);

class MyDio {
  static String baseUrl = ApiPaths.baseUrl;

  late Dio _dio;

  MyDio() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 60 * 500,
      receiveTimeout: 60 * 1000,
      responseType: ResponseType.plain,
      headers: {
        Headers.contentTypeHeader: "application/json",
      },
    );

    _dio = Dio(options);

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return null;
    };
  }

  Future<dynamic> get(String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      Response resp = await _dio.get(
        path, // No need to add baseUrl, Dio handles it
        queryParameters: queryParameters,
        options: options ??
            Options(
              responseType: ResponseType.plain,
              headers: {
                Headers.contentTypeHeader: "application/json",
              },
            ),
      );

      debugPrint("!!!!!!!!!!!!!! Request Begin !!!!!!!!!!!!!!!!!!!!!");
      debugPrint(
          "REQUEST[${resp.statusCode}] => PATH: ${resp.requestOptions.uri}");
      debugPrint("ResMethodType : [${resp.requestOptions.method}]");

      if (resp.data
          .toString()
          .isNotEmpty) {
        return jsonDecode(resp.data);
      }
      return null;
    } on DioError catch (e) {
      debugPrint("!!!!!!!!!!!!!! Error Begin !!!!!!!!!!!!!!!!!!!!!");
      debugPrint(
          "REQUEST[${e.response?.statusCode}] => PATH: ${e.requestOptions
              .uri}");

      throw Exception('Error: ${e.message}');
    }
  }
}