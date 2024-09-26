import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tarlan_payments/data/model/common/supported_locale.dart';
import 'package:tarlan_transaction_generator/tarlan_transaction_generator.dart';

import '../domain/providers/locale_provider.dart';
import '../network/environment.dart';
import '../utils/tarlan_builder.dart';
import 'mock_data.dart';

class TransactionUrlProvider extends ChangeNotifier {
  final TarlanTransactionGenerator generator;
  Environment currentEnvironment = Environment.prod;
  bool isLoading = false;
  String? transactionLink;
  String? error;
  String? locale = 'en';

  TransactionUrlProvider() : generator = TarlanTransactionGenerator(secret: secret, environment: Environment.prod.name);

  Future<void> createTransaction(String type) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      String? response;
      switch (type) {
        case 'PayIn':
          response = await generator.createPayIn(requestData);
          break;
        case 'PayOut':
          response = await generator.createPayOut(requestData);
          break;
        case 'CardLink':
          response = await generator.createCardLink(cardLinkRequestData);
          break;
      }
      if (response != null && isValidUrl(response)) {
        transactionLink = response;
      } else {
        error = response;
      }
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  void switchEnvironment() {
    currentEnvironment = currentEnvironment == Environment.prod ? Environment.sandbox : Environment.prod;
    generator.environment = currentEnvironment.name;
    notifyListeners();
  }

  void switchLocale(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    if (localeProvider.locale.languageCode == 'en') {
      locale = 'Русский';
      localeProvider.setLocale(const Locale('ru'));
    } else {
      locale = 'English';
      localeProvider.setLocale(const Locale('en'));
    }
  }

  void clear() {
    error = null;
    transactionLink = null;
    notifyListeners();
  }

  String randomReferenceId(String input) {
    final parts = input.split('-');
    final numericPart = Random().nextInt(9000) + 1000;
    return '${parts.sublist(0, parts.length - 1).join('-')}-$numericPart';
  }

  void generateRandomReferenceId() {
    final input = requestData['project_reference_id'];
    requestData['project_reference_id'] = randomReferenceId(input);
    notifyListeners();
  }

  void generateRandomClientId() {
    final newId = Random().nextInt(900) + 100;
    requestData['project_client_id'] = 'sdkmobile$newId';
    cardLinkRequestData['project_client_id'] = 'sdkmobile$newId';
    notifyListeners();
  }

  void launchTarlanSDK(BuildContext context, String url, Environment currentEnvironment) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    SupportedLocale supportedLocale =
        localeProvider.locale.languageCode == 'en' ? SupportedLocale.en : SupportedLocale.ru;
    TarlanBuilder(context: context, url: url)
        .onSuccess(() => debugPrint('Success callback triggered!'))
        .onError(() => debugPrint('Error callback triggered!'))
        .language(supportedLocale)
        .environment(currentEnvironment)
        .merchantId(requestData['merchant_id'].toString())
        .projectId(requestData['project_id'].toString())
        .initialize();
  }
}
