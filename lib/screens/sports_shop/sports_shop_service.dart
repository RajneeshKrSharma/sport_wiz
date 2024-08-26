import 'package:flutter/material.dart';
import 'package:flutter_learning/network/api_call.dart';
import 'package:flutter_learning/network/api_relative_urls.dart';
import 'package:flutter_learning/network/network_utils.dart';

import '../../network/api_base_url.dart';

class SportsShopService {
  static dynamic callSportsShopApi(BuildContext context, Map<String, dynamic> requestBody) async => await CallApi.callApi(BaseUrl, MethodType.post, postDataApi, requestBody: requestBody);
}