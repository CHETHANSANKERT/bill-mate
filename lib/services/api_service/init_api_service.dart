// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../utils/app_snackbar.dart';
import '../local/encryption.dart';
import '../local/logger.dart';
import '../local/user_provider.dart';

/// DIO interceptor to add the authentication token
InterceptorsWrapper addAuthToken({String authTokenHeader = 'authToken'}) =>
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        options.headers.addAll(<String, dynamic>{
          authTokenHeader: (UserProvider.authToken ?? '').isEmpty
              ? ''
              : 'Bearer ${UserProvider.authToken}',
        });
        handler.next(options); //continue
      },
    );

/// Dio interceptor to encrypt the request body
InterceptorsWrapper encryptBody() => InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        final String method = options.method.toUpperCase();

        if (options.headers['encrypt'] as bool) {
          switch (method) {
            case 'POST':
            case 'PUT':
            case 'PATCH':
              logW('encrypting $method method');
              if (options.data.runtimeType.toString() ==
                  '_InternalLinkedHashMap<String, dynamic>') {
                logI('Data will be encrypted before sending request');
                options.data = <String, dynamic>{
                  'data': AppEncryption.encrypt(
                      plainText: jsonEncode(options.data)),
                };
              } else {
                logI(
                    'Skipping encryption for ${options.data.runtimeType} type');
              }

              break;
            default:
              logWTF('Skipping encryption for $method method');
              break;
          }
        }
        handler.next(options); //continue
      },
    );

/// API service of the application. To use Get, POST, PUT and PATCH rest methods
class APIService {
  static final Dio _dio = Dio();

  static late String _prodBaseApiUrl;
  static late String _devBaseApiUrl;

  /// API base URL
  static String get baseUrl => kReleaseMode ? _prodBaseApiUrl : _devBaseApiUrl;
  static String get userImageBaseUrl => '${baseUrl}images/';

  ///https://lms-prod.jmrinfotech.com/note/download?filepath=
  static String get userFileBaseUrl => '${baseUrl}note/download?filepath=';

  static String get blogMainImageUrl => '${baseUrl}main_image';
  static String get blogVideoUrl => '${baseUrl}main_image';

  /// Initialize the API service
  static Future<void> initializeAPIService({
    required String devBaseUrl,
    required String prodBaseUrl,
    bool encryptData = false,
    String authHeader = 'authToken',
    String xAPIKeyHeader = 'x-api-key',
    String xAPIKeyValue = 'x-api-key',
  }) async {
    String cookiePath = '';

    // final Directory dir = await getApplicationDocumentsDirectory();
    // cookiePath = '${dir.path}/.cookies/';
    if (!kIsWeb) {
      final Directory dir = await getApplicationDocumentsDirectory();
      cookiePath = '${dir.path}/.cookies/';
      _dio.interceptors.add(CookieManager(PersistCookieJar(
        ignoreExpires: true,
        storage: FileStorage(cookiePath),
      )));
    }
    _devBaseApiUrl = devBaseUrl;
    _prodBaseApiUrl = prodBaseUrl;

    /* void saveDataToLocalStorage(String key, String value) {
      if (kIsWeb) {
        html.window.localStorage[key] = value;
      }
    }

    String? getDataFromLocalStorage(String key) {
      if (kIsWeb) {
        return html.window.localStorage[key];
      }
      return null;
    }*/

    _dio.options.headers.addAll(<String, dynamic>{
      xAPIKeyHeader: xAPIKeyValue,
    });
    /*if (UserProvider.isLoggedIn) {
      _dio.options.headers.addAll(<String, dynamic>{
        authHeader: UserProvider.authToken,
      });
    }*/
    _dio.interceptors.add(addAuthToken(authTokenHeader: authHeader));
    //Add interceptor for encryption layer
    if (encryptData) {
      logI('Data will be encrypted for POST / PUT / PATCH');
      _dio.interceptors.add(encryptBody());
    }
    if (kDebugMode) {
      //Add interceptor for console logs
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ));
    }

    // _restClient.getTasks();
  }

  /// GET rest API call
  /// Used to get data from backend
  ///
  /// Use [forcedBaseUrl] when want to use specific baseurl other
  /// than configured
  ///
  /// The updated data to be passed in [blogDetails]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  /// set [encrypt] to true if the body needs to be encrypted. Make sure the
  /// encryption keys in the backend matches with the one in frontend
  static Future<Response<Map<String, dynamic>?>?> get({
    required String path,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
    bool? isFromPM,
  }) async {
    try {
      return await _dio.get<Map<String, dynamic>?>(
          (forcedBaseUrl ?? baseUrl) + path,
          queryParameters: params,
          /*options: Options(headers: <String, dynamic>{
            'encrypt': encrypt,
          }),*/
          options: Options(headers: getOptionsHeaders(forcedBaseUrl, false)));
    } on DioException catch (error) {
      if ([400, 500, 401, 403].contains(error.response?.statusCode)) {
        return Response<Map<String, dynamic>?>(
            data: error.response?.data,
            requestOptions: error.requestOptions,
            statusCode: error.response?.statusCode);
      }
      if ((error.error is SocketException) ||
          (error.type == DioExceptionType.connectionTimeout)) {
        appSnackbar(
          message: 'Please check your network connection',
          snackbarState: SnackbarState.warning,
        );
      }
      // return error.response?.data ?? '';
    }
    return null;
  }

  /// POST rest API call
  /// Used to send any data to server and get a response
  ///
  /// Use [forcedBaseUrl] when want to use specific baseurl other
  /// than configured
  ///
  /// The updated data to be passed in [data]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  static Future<Response<Map<String, dynamic>?>?> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
  }) async {
    try {
      return await _dio.post<Map<String, dynamic>?>(
        (forcedBaseUrl ?? baseUrl) + path,
        // options: Options(
        //   headers: <String, String>{
        //     'Content-Length':utf8.encode(body).length
        //   }
        // ),
        data: data,
        queryParameters: params,
        options: Options(headers: getOptionsHeaders(forcedBaseUrl, false)),
      );
    } on DioException catch (error) {
      if ([400, 500, 401, 403].contains(error.response?.statusCode)) {
        return Response<Map<String, dynamic>?>(
            data: error.response?.data,
            requestOptions: error.requestOptions,
            statusCode: error.response?.statusCode);
      }
      if ((error.error is SocketException) ||
          (error.type == DioExceptionType.connectionTimeout)) {
        appSnackbar(
          message: 'Please check your network connection',
          snackbarState: SnackbarState.warning,
        );
      }
      return error.response?.data;
    }
  }

  static Future<Response<Map<String, dynamic>?>?> postwithjson({
    required String path,
    dynamic data,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
  }) async {
    try {
      return await _dio.post<Map<String, dynamic>?>(
        (forcedBaseUrl ?? baseUrl) + path,
        /*options: Options(
            // contentType: 'application/json',
            headers: <String, String>{
              'Content-Type': 'application/json',
            }),*/
        options: Options(headers: getOptionsHeaders(forcedBaseUrl, true)),
        data: data,
        queryParameters: params,
      );
    } on DioException catch (error) {
      if ([400, 500, 401, 403].contains(error.response?.statusCode)) {
        return Response<Map<String, dynamic>?>(
            data: error.response?.data,
            requestOptions: error.requestOptions,
            statusCode: error.response?.statusCode);
      }

      if ((error.error is SocketException) ||
          (error.type == DioExceptionType.connectionTimeout)) {
        appSnackbar(
          message: 'Please check your network connection',
          snackbarState: SnackbarState.warning,
        );
      }
      return error.response?.data;
    }
  }

  /// PUT rest API call
  /// Usually used to create new record
  ///
  /// Use [forcedBaseUrl] when want to use specific baseurl other
  /// than configured
  ///
  /// The updated data to be passed in [data]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  static Future<Response<Map<String, dynamic>?>?> put({
    required String path,
    FormData? data,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
  }) async {
    try {
      return await _dio.put<Map<String, dynamic>?>(
        (forcedBaseUrl ?? baseUrl) + path,
        data: data,
        queryParameters: params,
        options: Options(headers: getOptionsHeaders(forcedBaseUrl, false)),
      );
    } on DioException catch (error) {
      if ([400, 500, 401, 403].contains(error.response?.statusCode)) {
        return Response<Map<String, dynamic>?>(
            data: error.response?.data,
            requestOptions: error.requestOptions,
            statusCode: error.response?.statusCode);
      }

      if ((error.error is SocketException) ||
          (error.type == DioExceptionType.connectionTimeout)) {
        appSnackbar(
          message: 'Please check your network connection',
          snackbarState: SnackbarState.warning,
        );
      }
      return error.response?.data;
    }
  }

  static Future<Response<Map<String, dynamic>?>?> putwithJson({
    required String path,
    dynamic data,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
  }) async {
    try {
      return await _dio.put<Map<String, dynamic>?>(
        (forcedBaseUrl ?? baseUrl) + path,
        /*options: Options(headers: <String, String>{
          'Content-Type': 'application/json',
        }),*/
        options: Options(headers: getOptionsHeaders(forcedBaseUrl, true)),
        data: data,
        queryParameters: params,
      );
    } on DioException catch (error) {
      if ([400, 500, 401, 403].contains(error.response?.statusCode)) {
        return Response<Map<String, dynamic>?>(
            data: error.response?.data,
            requestOptions: error.requestOptions,
            statusCode: error.response?.statusCode);
      }

      if ((error.error is SocketException) ||
          (error.type == DioExceptionType.connectionTimeout)) {
        appSnackbar(
          message: 'Please check your network connection',
          snackbarState: SnackbarState.warning,
        );
      }
      return error.response?.data;
    }
  }

  /// PATCH rest API call
  /// Usually used to update any record
  ///
  /// Use [forcedBaseUrl] when want to use specific baseurl other
  /// than configured
  ///
  /// The updated data to be passed in [data]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  static Future<Response<Map<String, dynamic>?>?> patch({
    required String path,
    FormData? data,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
  }) async {
    try {
      return await _dio.patch<Map<String, dynamic>?>(
        (forcedBaseUrl ?? baseUrl) + path,
        data: data,
        queryParameters: params,
        options: Options(headers: getOptionsHeaders(forcedBaseUrl, false)),
      );
    } on DioException catch (error) {
      if ([400, 500, 401, 403].contains(error.response?.statusCode)) {
        return Response<Map<String, dynamic>?>(
            data: error.response?.data,
            requestOptions: error.requestOptions,
            statusCode: error.response?.statusCode);
      }

      if ((error.error is SocketException) ||
          (error.type == DioExceptionType.connectionTimeout)) {
        appSnackbar(
          message: 'Please check your network connection',
          snackbarState: SnackbarState.warning,
        );
      }
      return error.response?.data;
    }
  }

  /// due to form data the empty string was not accepted and was not sent so
  static Future<Response<Map<String, dynamic>?>?> patchWithJson({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
  }) async {
    try {
      return await _dio.patch<Map<String, dynamic>?>(
        (forcedBaseUrl ?? baseUrl) + path,
        data: data,
        queryParameters: params,
        options: Options(headers: getOptionsHeaders(forcedBaseUrl, false)),
      );
    } on DioException catch (error) {
      if ([400, 500, 401, 403].contains(error.response?.statusCode)) {
        return Response<Map<String, dynamic>?>(
            data: error.response?.data,
            requestOptions: error.requestOptions,
            statusCode: error.response?.statusCode);
      }

      if ((error.error is SocketException) ||
          (error.type == DioExceptionType.connectionTimeout)) {
        appSnackbar(
          message: 'Please check your network connection',
          snackbarState: SnackbarState.warning,
        );
      }
      return error.response?.data;
    }
  }

  /// Upload file to the server. You will get the URL in the response if the
  /// [file] was uploaded successfully. Else you will get null in response.
  static Future<String?> uploadFile({
    required File file,
    required String folder,
  }) async {
    final Response<Map<String, dynamic>?>? response = await APIService.post(
      path: '/user/upload/$folder/images',
      data: FormData.fromMap(<String, dynamic>{
        'images': MultipartFile.fromBytes(
          List<int>.from(await file.readAsBytes()),
          contentType:
              http_parser.MediaType('image', path.extension(file.path)),
          filename: file.path,
        ),
      }),
    );

    if (response?.statusCode == 200) {
      if (response?.data!['code'] == 'FILE_UPLOADED') {
        logE(response?.data!['file']);
        return response?.data!['file'] as String;
      } else {
        appSnackbar(
          message: 'Something went wrong',
          snackbarState: SnackbarState.warning,
        );
        return null;
      }
    } else {
      appSnackbar(
        message: response.toString(),
        snackbarState: SnackbarState.error,
      );
    }
    return null;
  }

  static Map<String, String> getOptionsHeaders(
      String? forcedBaseUrl, bool isHeaderRequired) {
    final Map<String, String> data = <String, String>{};
    if (UserProvider.isLoggedIn) {
      data['Authorization'] = UserProvider.authToken ?? '';
    }
    if (isHeaderRequired) {
      data['Content-Type'] = 'application/json';
    }
    return data;
  }

  /// Call this get method for different host rather than PM URl and Base URl
  static Future<Response<Map<String, dynamic>?>?> getForOuterURL({
    required String path,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
  }) async {
    try {
      return await _dio.get<Map<String, dynamic>?>((forcedBaseUrl ?? '') + path,
          queryParameters: params,
          options: Options(contentType: 'application/json'));
    } on DioException catch (error) {
      if ([400, 500, 401, 403].contains(error.response?.statusCode)) {
        return Response<Map<String, dynamic>?>(
            data: error.response?.data,
            requestOptions: error.requestOptions,
            statusCode: error.response?.statusCode);
      }

      if ((error.error is SocketException) ||
          (error.type == DioExceptionType.connectionTimeout)) {
        appSnackbar(
          message: 'Please check your network connection',
          snackbarState: SnackbarState.warning,
        );
      }
      return error.response?.data;
    }
  }
}
