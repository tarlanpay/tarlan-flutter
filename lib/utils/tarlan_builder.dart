import 'package:flutter/material.dart';
import '/network/environment.dart';

import '../data/model/common/session_data.dart';
import '../data/model/common/url_data.dart';
import '../screens/parent.dart';

class TarlanBuilder {
  final BuildContext context;
  final String url;
  VoidCallback? _onSuccess;
  VoidCallback? _onError;
  String? _language;
  Environment? _environment;
  String? _merchantId;
  String? _projectId;

  TarlanBuilder({
    required this.context,
    required this.url,
  });

  TarlanBuilder onSuccess(VoidCallback callback) {
    _onSuccess = callback;
    return this;
  }

  TarlanBuilder onError(VoidCallback callback) {
    _onError = callback;
    return this;
  }

  TarlanBuilder language(String language) {
    _language = language;
    return this;
  }

  TarlanBuilder environment(Environment environment) {
    _environment = environment;
    return this;
  }

  TarlanBuilder merchantId(String merchantId) {
    _merchantId = merchantId;
    return this;
  }

  TarlanBuilder projectId(String projectId) {
    _projectId = projectId;
    return this;
  }

  void initialize() {
    var session = SessionData();
    session.setEnvironment(_environment);
    session.setLanguage(_language);
    session.setUrlData(UrlData.fromUrl(url));
    session.setOnError(_onError);
    session.setOnSuccess(_onSuccess);
    session.setMerchantId(_merchantId);
    session.setProjectId(_projectId);

    debugPrint('Processing URL: $url');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TarlanParentWidget()),
    );
  }
}
