import 'package:flutter/widgets.dart';
import '/data/model/transaction/colors_info.dart';
import '/data/model/transaction/merchant_info.dart';
import '/data/webservices/errors.dart';
import '/network/api_client.dart';
import '/network/api_type.dart';
import '/network/request.dart';

import '../../model/common/session_data.dart';

class MerchantWebService {
  final api = ApiClient();

  Future<ColorsInfo> getColorsInfo() async {
    var sessionData = SessionData();
    var merchantId = sessionData.getMerchantId();
    var projectId = sessionData.getProjectId();
    var path = '/view-crafter/api/v1/color/merchants/$merchantId/projects/$projectId';
    final request = Request(path: path, apiType: ApiType.merchant);
    try {
      final response = await api.send(request);
      if (response.statusCode == 200) {
        return colorsInfoFromJson(response.body).result;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ErrorsResponse(response: e.toString());
    }
    throw ErrorsResponse(response: 'Unknown');
  }

  Future<MerchantInfo> getMerchantInfo() async {
    var sessionData = SessionData();
    var merchantId = sessionData.getMerchantId();
    var projectId = sessionData.getProjectId();
    var path = '/view-crafter/api/v1/pay-form/merchants/$merchantId/projects/$projectId';
    final request = Request(path: path, apiType: ApiType.merchant);
    try {
      final response = await api.send(request);
      if (response.statusCode == 200) {
        return merchantInfoFromJson(response.body).result;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ErrorsResponse(response: e.toString());
    }
    throw ErrorsResponse(response: 'Unknown');
  }
}
