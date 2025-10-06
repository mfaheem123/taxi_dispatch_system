
// ignore_for_file: invalid_required_positional_param, unrelated_type_equality_checks, use_rethrow_when_possible, empty_constructor_bodies

import 'dart:async';

import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetry requestRetry;
  bool error = false;
  bool firstTime;

  RetryOnConnectionChangeInterceptor(
      {required this.requestRetry, this.firstTime = false});

  @override
  Future onError(DioException err, handler) async {
    // TODO: implement onError
    if (_shouldRetry(err, firstTime: firstTime)) {
      try {
        if (err.response == null) {
          return requestRetry.scheduleRequestRetry(err, handler);
        }
      } catch (e) {
        return super.onError(err, handler);
      }
    }
    return err;
  }

  bool _shouldRetry(DioException err, {firstTime}) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.unknown) {
      if (error == false) {
        error = true;
        if (firstTime == true) {
          showLoading();
        }
        BotToast.showText(text: 'Internet Error !! Retrying');
        // Future.delayed(Duration(seconds: 8), () {
        //   error = false;
        // });
      }
      return true;
    } else {
      if (err.type == DioExceptionType.connectionTimeout) {
        BotToast.closeAllLoading();
        return Api.singleton.returnResponse(err.response);
      }
      if (err.type == DioExceptionType.receiveTimeout) {
        BotToast.closeAllLoading();
        return Api.singleton.returnResponse(err.response);
      }
      print("error response is ${err.response!.requestOptions.path}");
      BotToast.closeAllLoading();
      return Api.singleton.returnResponse(err.response);
    }
  }
}

class DioConnectivityRequestRetry {
  final Dio? dio;
  final Connectivity? connectivity;

  DioConnectivityRequestRetry({
    required this.dio,
    required this.connectivity,
  });

  void scheduleRequestRetry(DioException error, ErrorInterceptorHandler handler) {
    late StreamSubscription streamSubscription;
    streamSubscription = connectivity!.onConnectivityChanged.listen(
          (connectivityResult) async {
        if (connectivityResult != ConnectivityResult.none) {
          streamSubscription.cancel();
          try {
            var response = await dio!.fetch(error.requestOptions);
            handler.resolve(response);
          } on DioException catch (retryError) {
            handler.next(retryError);
          }
        }
      },
    );
  }
}