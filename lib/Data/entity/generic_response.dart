class GeneralResponse {
  final String? response;
  final String? message;
  final int? currentBalance;

  GeneralResponse({
    this.response,
    this.message,
    this.currentBalance
  });

  factory GeneralResponse.fromMap(Map<String, dynamic> userData) {
    return GeneralResponse(
        response: userData['response'],
        message: userData['message'],
        currentBalance: userData['currentBalance']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'response': response,
      'message': message,
      'currentBalance': currentBalance
    };
  }

  factory GeneralResponse.fromJson(Map<String, dynamic> json) => GeneralResponse(
      response: json['response'],
      message: json['message'],
      currentBalance: json['currentBalance']
  );

}