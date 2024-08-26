import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_learning/hardcoded_api_resp.dart';
import 'package:flutter_learning/result.dart';
import 'package:flutter_learning/screens/sports_shop/SportsShopResponse.dart';
import 'package:flutter_learning/screens/sports_shop/sports_shop_service.dart';

class SportsShopLogic {
  static Future<Result<dynamic>> callSportsShopApi(BuildContext context) async {

    dynamic jsonMap = await SportsShopService.callSportsShopApi(context, jsonDecode(dummyJson));

    try {
      var respObj = SportsShopResponse.fromJson(jsonMap);
      return Result.responseSuccess(data: respObj);
    } catch (e) {
      if (jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);
      } else {
        return Result.failure(
            data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {
              "occurredErrorDescriptionMsg": e
            });
      }
    }
  }
}