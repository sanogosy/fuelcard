class TransfertResponse {
  final String? response;
  final String? message;
  final int? currentBalance;

  TransfertResponse({
    this.response,
    this.message,
    this.currentBalance
  });

  factory TransfertResponse.fromMap(Map<String, dynamic> userData) {
    return TransfertResponse(
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

  factory TransfertResponse.fromJson(Map<String, dynamic> json) => TransfertResponse(
    response: json['response'],
    message: json['message'],
    currentBalance: json['currentBalance']
  );

}