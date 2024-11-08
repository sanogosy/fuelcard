class UserAccount {
  final String? id;
  final String name;
  final String? avatarUrl;
  final String? email;
  final String? type_compte;
  final String? tel;
  final String? balance;
  final String? response;
  final String? message;
  final int? authorized;
  final int? deleted;

  UserAccount({
    this.id,
    required this.name,
    this.avatarUrl,
    this.tel,
    this.response,
    this.message,
    this.email,
    this.type_compte,
    this.balance,
    required this.authorized,
    required this.deleted,
  });

  factory UserAccount.fromMap(Map<String, dynamic> userData) {
    return UserAccount(
      id: userData['id'],
      name: userData['name'],
      avatarUrl: userData['avatarUrl'],
      tel: userData['tel'],
      type_compte: userData['type_compte'],
      message: userData['message'],
      response: userData['response'],
      email: userData['email'],
      balance: userData['balance'],
      authorized: userData['authorized'],
      deleted: userData['deleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'tel': tel,
      'email': email,
      'response': response,
      'message': message,
      'type_compte': type_compte,
      'balance': balance,
      'authorized': authorized,
      'deleted': deleted,
    };
  }

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      tel: json['tel'],
      response: json['response'],
      message: json['message'],
      type_compte: json['type_compte'],
      email: json['email'],
      balance: json['balance'],
      authorized: json['authorized'],
      deleted: json['deleted'],
  );

  @override
  String toString() {
    return name;
  }
}