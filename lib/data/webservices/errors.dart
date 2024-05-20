class SerializationError extends Error {
  final dynamic inner;
  SerializationError([this.inner]);
}

class ErrorsResponse extends Error {
  final String response;
  ErrorsResponse({required this.response});
}

class InvalidResponse extends Error {
  final String response;
  InvalidResponse(this.response);
}
