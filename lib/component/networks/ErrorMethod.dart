import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

dynamic returnResponse(Response? responseData) {
  if (responseData == null) {
    BotToast.showText(text: 'Internet Error');
  }

  ///video delete
  else if (responseData.statusCode == 400 &&
      responseData.data['error'] == "Video Deleted") {
    BotToast.showText(text: 'Video Deleted');
  } else {
    print(responseData.data['error']);
    // BotToast.showText(text: 'Video Not Found');
    switch (responseData.statusCode) {
      case 200:
        var responseJson = json.decode(responseData.data.toString());
        //print(responseJson);
        return responseJson;
      case 400:
        BotToast.showText(text: responseData.data["message"][0].toString());
        break;
      case 401:
        BotToast.showText(text: responseData.data["message"][0].toString());
        break;
      case 404:
        BotToast.showText(text: responseData.data["message"][0].toString());
        break;
      case 403:
        BotToast.showText(text: responseData.data["message"][0].toString());
        break;
      case 500:
      default:
        throw BotToast.showText(
            text:
            ('Error occurred while Communication with Server with StatusCode : ${responseData.statusCode}'));
    }
  }
}