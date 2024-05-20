const secret = "cC5Q4j87BNTe3vXgyd2t";

Map<String, dynamic> requestData = {
  "amount": 12,
  "callback_url": "https://nomad.kz/test.php?order-id=test-request-3",
  "description": "Test Description",
  "failure_redirect_url": "https://nomad.kz/test.php?status=failure\u0026order-id=test-request-3",
  "is_hold": false,
  "merchant_id": 10,
  "project_client_id": "sdkmobile3",
  "project_id": 10,
  "project_reference_id": "test-request-400",
  "success_redirect_url": "https://nomad.kz/test.php?status=success\u0026order-id=test-request-3"
};

Map<String, dynamic> cardLinkRequestData = {
  "callback_url": "https://nomad.kz/test.php?order-id=test-request-3",
  "description": "Test Description",
  "failure_redirect_url": "https://nomad.kz/test.php?status=failure\u0026order-id=test-request-3",
  "merchant_id": 10,
  "project_client_id": "sdkmobile3",
  "project_id": 10,
  "success_redirect_url": "https://nomad.kz/test.php?status=success\u0026order-id=test-request-3"
};
