class APIError {
  final String message;
  final int code;

  APIError({this.message = "An error occurred", this.code = 500});
}
