import 'dart:convert';

import 'package:crypto/crypto.dart';

class TarlanSignature {
  static String hashedSecretKey(Map<String, dynamic> requestData, String secret) {
    // Sort the request data by keys in alphabetical order
    List<String> sortedKeys = requestData.keys.toList()..sort();
    Map<String, dynamic> sortedData = {};
    for (String key in sortedKeys) {
      sortedData[key] = requestData[key];
    }

    // Encode the sorted request data to JSON
    String sortedJson = _convertAmpersand(jsonEncode(sortedData));

    // Encode the sorted JSON to base64
    String base64EncodedData = base64Encode(utf8.encode(sortedJson));

    // Concatenate the base64-encoded data with the secret
    String dataToSign = base64EncodedData + secret;

    // Hash the result to SHA-256
    String sha256Hash = sha256.convert(utf8.encode(dataToSign)).toString();

    final result = sha256Hash.toString();

    return 'Bearer $result';
  }

  static String _convertAmpersand(String json) {
    return json.replaceAll('&', '\\u0026');
  }
}
