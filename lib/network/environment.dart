enum Environment {
  prod,
  sandbox;

  factory Environment.fromString(String? env) {
    if (env == 'sandbox') {
      return sandbox;
    } else {
      return prod;
    }
  }
}
