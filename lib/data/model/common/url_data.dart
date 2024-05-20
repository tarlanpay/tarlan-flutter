class UrlData {
  final String hash;
  final String transactionId;
  final String rawUrl;
  UrlData({required this.hash, required this.transactionId, required this.rawUrl});

  factory UrlData.fromUrl(String url) {
    // Split the URL string by '?' to get the parameters
    List<String> parts = url.split('?');
    if (parts.length != 2) {
      throw ArgumentError('Invalid URL format');
    }

    // Split the parameters by '&' to get key-value pairs
    List<String> params = parts[1].split('&');

    String hash = '';
    String transactionId = '';

    // Iterate through the key-value pairs and extract hash and transactionId
    for (String param in params) {
      List<String> keyValue = param.split('=');
      if (keyValue.length != 2) {
        throw ArgumentError('Invalid parameter format');
      }
      if (keyValue[0] == 'hash') {
        hash = keyValue[1];
      } else if (keyValue[0] == 'transaction_id') {
        transactionId = keyValue[1];
      }
    }

    return UrlData(hash: hash, transactionId: transactionId, rawUrl: url);
  }
}
