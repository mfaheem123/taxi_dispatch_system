

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/View/Chat/view/messageTile.dart';
import 'package:bloodlines/notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bloodlines/Components/Network/interceptor.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'Url.dart';

final String baseUrl = Environment().config.baseUrl;
final String apiUrl = Environment().config.apiUrl;
final String imageUrl = Environment().config.imageUrl;
final String slashImageUrl = Environment().config.slashImageUrl;
final String socketUrl = Environment().config.socketUrl;

String checkImageUrl(String type) =>
    "https://bloodlines.gologonow.app/uploads$type/default.png";

const String groupPlaceholder =
    "https://www.kindpng.com/picc/m/419-4196045_group-head-avatar-icon-group-png-transparent-png.png";

class Api {
  static final Api singleton = Api._internal();
  factory Api() {
    return singleton;
  }

  Api._internal();

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
        return returnResponse(e.response!);
      }
    }
  }

  final notifications = FlutterLocalNotificationsPlugin();
  getx.RxDouble progress = 0.0.obs;
  CancelToken cancelToken = CancelToken();
  Future<dynamic> messagePost(formData, url,
      {auth = false,
        multiPart = false,
        nonFormContent = false,
        isProgressShow = false,
        video = false,
        fromChat = false,
        int? rand,
        String? inboxId,
        fullUrl}) async {
    if (isProgressShow == false) {
      showLoading();
    }
    // if(fullUrl != null){
    //   if (fullUrl.contains("http://18.223.229.217/api/")) {
    //     fullUrl = fullUrl.replaceFirst("http://18.223.229.217/api/",
    //         "http://18.223.229.217/hero-self/api/");
    //   }
    // }
    if (cancelToken.isCancelled) {
      cancelToken = CancelToken();
    }
    Dio dio = Dio();

    dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";

    try {
      dynamic response = await dio.post(
        fullUrl ?? apiUrl + url,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: video == true
            ? (int sent, int total) {
          onProgress(video, rand, total, sent, fullUrl,
              inboxId: inboxId, fromChat: true);
        }
            : null,
        options: Options(
          headers: {
            Headers.acceptHeader: "application/json",
          },
          contentType: 'multipart/form-data',
        ),
      );
      BotToast.closeAllLoading();

      return response;
    } on DioException catch (e) {
      BotToast.closeAllLoading();

      if (e.type == DioExceptionType.connectionError) {
        BotToast.showText(text: 'No Internet connection');
      }
      return returnResponse(e.response);
    } on SocketException catch (e) {
      BotToast.closeAllLoading();
      print("error $e");
    }
  }

  onProgress(video, rand, total, sent, fullUrl, {inboxId, fromChat = false}) {
    videoProgress.value = (sent / total);
    print(videoProgress.value);

    if (videoProgress.value == 1.0) {
      if (fromChat == true) {
        if (inboxId != null) {
          ChatController controller = getx.Get.find();
          controller.getUserChat(inboxId, fullUrl: fullUrl);
        }
      }
    }

    if (video == true) {
      if ((sent / total * 100).toInt() != 100) {
        noti((sent / total * 100).toInt(), rand);
      } else {
        notifications.cancel(rand);
        notifications.show(
          rand,
          fromChat == true ? 'Bloodlines' : 'Uploading Post',
          'Upload Completed',
          NotificationDetails(
            android: AndroidNotificationDetails(
              'DemoTestChannel',
              'High Importance Notifications',
              progress: total,
              icon: 'ic_launcher',
              enableVibration: false,
              importance: Importance.high,
              onlyAlertOnce: true,
              channelShowBadge: false,
            ),
            iOS: const DarwinNotificationDetails(),
          ),
        );
      }
    }
  }

  Future<dynamic> get(String url,
      {fullUrl, queryParameters, auth = false}) async {
    Dio dio = Dio(BaseOptions(
        connectTimeout: Duration(seconds: 50),
        receiveTimeout: Duration(seconds: 50),
        method: "GET"));
    print('Api Get, url $url');
    print("user auth token :: ${sp.read('token')}");
    print("api url :: ${fullUrl ?? apiUrl + url}");

    if (auth == false) {
      dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";
      // dio.options.headers['Connection'] = "keep-alive";
    }
    // if (url != "") {
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
      return returnResponse(e.response!);
    }
    // }
  }

  Future<dynamic> delete(formData, String url, {isProgressShow = false}) async {
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
      final response = await dio.post(
        apiUrl + url,
        data: formData,
        options: Options(
          headers: {
            Headers.acceptHeader: "application/json",
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
      return returnResponse(e.response!);
    }
  }

  post(formData, url,
      {auth = false,
        multiPart = false,
        nonFormContent = false,
        isProgressShow = false,
        noCloseLoading = false,
        fullUrl}) async {
    print('Api Post, url $url');

    if (isProgressShow == false) {
      showLoading();
    }

    try {
      dynamic response = await Dio().post(fullUrl ?? apiUrl + url,
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
      return response;
    } on DioException catch (e) {
      print("erro hide");
      if (isProgressShow == false) {
        BotToast.closeAllLoading();
      }

      if (e.type == DioExceptionType.unknown) {
        BotToast.showText(text: 'No Internet connection');
      } else {
        return returnResponse(e.response!);
      }
    }
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
              getx.Get.offAllNamed(Routes.login);
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
          getx.Get.offAllNamed(Routes.login);
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