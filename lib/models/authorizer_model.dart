class AuthorizerClass {
  final dynamic data;
  final String? error;
  final String? message;

  AuthorizerClass({
    this.data,
    this.error,
    this.message,
  });

  AuthorizerClass.fromJson(Map<String, dynamic> json)
      : data = json['data'],
        error = json['error'] as String?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'data' : data,
    'error' : error,
    'message' : message
  };
}