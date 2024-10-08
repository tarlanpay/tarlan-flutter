import 'package:flutter/material.dart';
import 'package:tarlan_payments/data/model/common/supported_locale.dart';

import '/network/environment.dart';
import 'url_data.dart';

class SessionData {
  SessionData._();

  static final SessionData _instance = SessionData._();

  factory SessionData() => _instance;

  SupportedLocale? _language;
  Environment? _environment;
  String? _merchantId;
  String? _projectId;
  UrlData? _urlData;
  String? _publicKey;
  String? _csrf;
  String? _session;
  VoidCallback? _onSuccess;
  VoidCallback? _onError;

  void setLanguage(SupportedLocale? lang) {
    _language = lang;
  }

  void setEnvironment(Environment? env) {
    _environment = env;
  }

  void setUrlData(UrlData? data) {
    _urlData = data;
  }

  void setOnSuccess(VoidCallback? onSuccess) {
    _onSuccess = onSuccess;
  }

  void setOnError(VoidCallback? onError) {
    _onError = onError;
  }

  void setMerchantId(String? merchantId) {
    _merchantId = merchantId;
  }

  void setProjectId(String? projectId) {
    _projectId = projectId;
  }

  void setPublicKey(String? publicKey) {
    _publicKey = publicKey;
  }

  void setCsrf(String? csrf) {
    _csrf = csrf;
  }

  void setSession(String? session) {
    _session = session;
  }

  String getLanguage() {
    return _language?.name ?? 'ru';
  }

  Environment getEnvironment() {
    return _environment ?? Environment.prod;
  }

  UrlData? getUrlData() {
    return _urlData;
  }

  String? getMerchantId() {
    return _merchantId;
  }

  String? getProjectId() {
    return _projectId;
  }

  String? getPublicKey() {
    return _publicKey;
  }

  String? getCsrf() {
    return _csrf;
  }

  String? getSession() {
    return _session;
  }

  void triggerOnSuccessCallback() {
    _onSuccess?.call();
  }

  void triggerOnErrorCallback() {
    _onError?.call();
  }
}
