

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dashboard_new1/component/networks/loader.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import '../../routes/app_pages.dart';
import 'Url.dart';
import 'dio_service.dart';
import 'interceptor.dart';

final String baseUrl = Environment().config.baseUrl;
final String apiUrl = Environment().config.apiUrl;
final String imageUrl = Environment().config.imageUrl;
final String slashImageUrl = Environment().config.slashImageUrl;
final String socketUrl = Environment().config.socketUrl;

String checkImageUrl(String type) =>
    "https://bloodlines.gologonow.app/uploads$type/default.png";

const String groupPlaceholder = "https://www.kindpng.com/picc/m/419-4196045_group-head-avatar-icon-group-png-transparent-png.png";

class Api {
  static final Api singleton = Api._internal();
  factory Api() {
    return singleton;
  }

  Api._internal();

// Company ID
  final String globalCompanyId = "3";

  var sp = GetStorage();
  Future<dynamic> interceptorGet(String url,
      {fullUrl, queryParameters, firstTime = false}) async {
    Dio dio = Dio(BaseOptions(
      connectTimeout: Duration(seconds: 50),
      receiveTimeout: Duration(seconds: 50),
    ));
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
          requestRetry: DioConnectivityRequestRetry(
            dio: dio,
            connectivity: Connectivity(),
          ),
          firstTime: firstTime),
    );

    dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";

    if (url != "") {
      try {
        final response = await dio.get(
          fullUrl ?? apiUrl + url,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              Headers.acceptHeader: "application/json",
            },
          ),
        );

        return response;
      } on SocketException {
        BotToast.showText(text: 'No Internet connection');
      } on DioException catch (e) {
        final failed = e.response;
        if (failed == null) return handleResponselessError(e);
        return returnResponse(failed);
      }
    }
  }


  dynamic injectCompanyId(data) {
    if (data == null) {
      return {'company_id': globalCompanyId};
    }

    if (data is Map<String, dynamic>) {
      return {
        ...data,
        'company_id': globalCompanyId,
      };
    }

    if (data is FormData) {
      // fields.add ki bajaye .fields.add use karein, jo aap kar rahe hain
      // Lekin verify karein ke backend 'company_id' hi expect kar raha hai
      data.fields.add(MapEntry('company_id', globalCompanyId));
      return data;
    }

    return data;
  }


  Future<dynamic> get(String url, {fullUrl, queryParameters, auth = false,
    sendCompanyId = false,
  }) async {
    Dio dio = Dio(BaseOptions(
        connectTimeout: Duration(seconds: 50),
        receiveTimeout: Duration(seconds: 50),
        method: "GET"));
    print('Api Get, url $url');
    print("user auth token :: ${sp.read('token')}");
    print("api url :: ${fullUrl ?? apiUrl + url}");


    // get CompanyID
    if (sendCompanyId == true && queryParameters != null) {
      queryParameters['company_id'] = globalCompanyId;
    }
    print("Final Query Parameters: $queryParameters");
    if (auth == false) {
      dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";
      // dio.options.headers['Connection'] = "keep-alive";
    }
    // if (url != "") {
    try {
      final response = await dio.get(
        fullUrl ?? apiUrl + url,
        queryParameters: queryParameters ?? (sendCompanyId == true ? {
          "company_id": globalCompanyId,
        } : {}),
        options: Options(
          headers: {
            Headers.acceptHeader: "application/json",
          },
        ),
      );
      return response;
    } on SocketException {
      BotToast.showText(text: 'No Internet connection');
    } on DioException catch (e) {
      final failed = e.response;
      if (failed == null) return handleResponselessError(e);
      return returnResponse(failed);
    }
    // }
  }


Future<dynamic> delete(String url, {isProgressShow = false, formData}) async {
     if (isProgressShow == false) {
      BotToast.showLoading();
    }
    Dio dio = Dio(BaseOptions(
      connectTimeout: Duration(seconds: 50),
      receiveTimeout: Duration(seconds: 50),
    ));
    dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";
    dio.options.headers['Connection'] = "keep-alive";

    try {
      var response = await dio.delete(
        data: formData??{},
        apiUrl + url,
        options: Options(
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      Future.delayed(Duration(seconds: 1), () {
        if (isProgressShow == false) {
          BotToast.closeAllLoading();
        }
      });

      return response;
    } on SocketException {
      Future.delayed(Duration(seconds: 1), () {
        if (isProgressShow == false) {
          BotToast.closeAllLoading();
        }
      });

      BotToast.showText(text: 'No Internet connection');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        BotToast.closeAllLoading();

        BotToast.showText(text: "Connection Timeout Exception");
        throw Exception("Connection Timeout Exception");
      }
      Future.delayed(Duration(seconds: 1), () {
        if (isProgressShow == false) {
          BotToast.closeAllLoading();
        }
      });

      final failed = e.response;
      if (failed == null) return handleResponselessError(e);
      return returnResponse(failed);
    }
  }


  post(formData, url,
      {auth = false,
        multiPart = false,
        nonFormContent = false,
        isProgressShow = false,
        noCloseLoading = false,
        bool sendCompanyId = false,
        fullUrl}) async {

    print('Api Post, url $url');

    if (isProgressShow == false) {
      showLoading();
    }
// --- Company ID
    if (sendCompanyId == true) {
      formData = injectCompanyId(formData);
    }

    try {
      // post method ke andar
      if (formData is FormData) {
        print("--- POST Debugging ---");
        print("Fields: ${formData.fields}");
        print("Files: ${formData.files}");
        print("----------------------");
      }
      // Timeouts, which a bare Dio() does not have: without them a host that
      // accepts the socket and then goes quiet leaves the request hanging on
      // the OS TCP timeout, and every screen awaiting it hangs with it.
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 50),
      ));
      dynamic response = await dio.post(fullUrl ?? apiUrl + url,
          data: formData,
          options: Options(
            method: "POST",
            contentType: multiPart == true
                ? 'multipart/form-data'
                : "application/x-www-form-urlencoded",
            headers: {
              "Connection": "keep-alive",
              "accept": "application/json",
              if (auth == false) "Authorization": "Bearer ${sp.read('token')}"
            },
          ));

      print("hide");
      if (isProgressShow == false) {
        if (noCloseLoading == false) {
          BotToast.closeAllLoading();
        }
      }

      print(apiUrl + url);
      return response;
    } on DioException catch (e) {
      print("erro hide");
      if (isProgressShow == false) {
        BotToast.closeAllLoading();
      }

      final failed = e.response;
      if (failed == null) return handleResponselessError(e);
      return returnResponse(failed);
    }
  }

  /// Handles a DioException that never got a response.
  ///
  /// Connection-level failures - a host that accepts nothing, a handshake that
  /// times out, DNS - arrive as a DioException whose `response` is null. Every
  /// call site used to force-unwrap that response inside the catch block, and
  /// the null check threw "Unexpected null value" from there, so what reached
  /// the caller was not a null response but an exception complaining about
  /// null. That is how a flaky backend turned into a login button that spins
  /// and reports nothing at all.
  ///
  /// Returns null, which callers already have to cope with: the `unknown`
  /// branch has always returned it.
  dynamic handleResponselessError(DioException e) {
    BotToast.closeAllLoading();
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        BotToast.showText(text: 'The server took too long to respond. Please try again.');
        break;
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        BotToast.showText(text: 'Could not reach the server. Please check your connection.');
        break;
      case DioExceptionType.cancel:
        break;
      default:
        BotToast.showText(text: 'Something went wrong. Please try again.');
    }
    print("Request failed without a response: ${e.type} ${e.message}");
    return null;
  }

  dynamic returnResponse(Response? response) {
    BotToast.closeAllLoading();
    if (response != null) {
      switch (response.statusCode) {
        case 200:
          var responseJson = json.decode(response.data.toString());
          print(responseJson);
          return responseJson;
        case 400:
          BotToast.showText(
              text: response.data["message"] ??
                  response.data['data'].values.toList().asMap().map(
                          (key, value) => MapEntry(key,
                          {BotToast.showText(text: value[0].toString())})));
          return response;
        case 401:
          if (response.requestOptions.path.contains("login")) {
            BotToast.showText(
                text: response.data["message"] ??
                    response.data['data'].values.toList().asMap().map(
                            (key, value) => MapEntry(key,
                            {BotToast.showText(text: value[0].toString())})));
          } else {
            if (count == 0) {
              count = 1;
              Future.delayed(Duration(seconds: 3), () {
                count = 0;
              });
              BotToast.showText(text: "Your session has been expired");
              Api.singleton.sp.erase();
              getx.Get.offAllNamed(Routes.loginScreen);
            }
          }
          return response;
        case 409:
          BotToast.showText(
              text: response.data["message"] ??
                  response.data['data'].values.toList().asMap().map(
                          (key, value) => MapEntry(key,
                          {BotToast.showText(text: value[0].toString())})));
          return response;

        case 410:
          BotToast.showText(
              text: response.data["message"] ??
                  response.data['data'].values.toList().asMap().map(
                          (key, value) => MapEntry(key,
                          {BotToast.showText(text: value[0].toString())})));
          getx.Get.back();
          return response;
        case 404:
          BotToast.showText(
              text: response.data["message"] ??
                  response.data['data'].values.toList().asMap().map(
                          (key, value) => MapEntry(key,
                          {BotToast.showText(text: value[0].toString())})));
          return response;
        case 403:
          BotToast.showText(
              text: response.data["message"] ??
                  response.data['data'].values.toList().asMap().map(
                          (key, value) => MapEntry(key,
                          {BotToast.showText(text: value[0].toString())})));
          return response;
        case 422:
          BotToast.showText(
              text: response.data["message"] ??
                  response.data['data'].values.toList().asMap().map(
                          (key, value) => MapEntry(key,
                          {BotToast.showText(text: value[0].toString())})));
          return response;
        case 420:
          BotToast.showText(
              text: "Your account has been deactivated by the admin");
          Api.singleton.sp.erase();
          getx.Get.offAllNamed(Routes.loginScreen);
          return response;
        case 500:
          BotToast.showText(text: 'Server not responding');
          return response;
        default:
          BotToast.showText(
              text:
              'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
          return response;
      }
    }

    BotToast.showText(text: 'Connection Error');
    throw SocketException("No Internet");

  }
}

int count = 0;