class AccountLogin {
  String? id;
  String? name;
  String? avatarUrl;
  String? tel;
  String? response;
  String? message;
  int? authorized;
  int? deleted;

  AccountLogin({
    this.id,
    this.name,
    this.avatarUrl,
    this.tel,
    this.response,
    this.message,
    this.authorized,
    this.deleted,
  });

  factory AccountLogin.fromMap(Map<String, dynamic> userData) {
    return AccountLogin(
      id: userData['id'],
      name: userData['name'],
      avatarUrl: userData['avatarUrl'],
      tel: userData['tel'],
      response: userData['response'],
      message: userData['message'],
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
      'response': response,
      'message': message,
      'authorized': authorized,
      'deleted': deleted,
    };
  }

  factory AccountLogin.fromJson(Map<String, dynamic> json) => AccountLogin(
    id: json['id'],
    name: json['name'],
    avatarUrl: json['avatarUrl'],
    tel: json['tel'],
    response: json['response'],
    message: json['message'],
    authorized: json['authorized'],
    deleted: json['deleted'],
  );

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }

  String? get getId {
    return id;
  }

  void set setId(String? Id) {
    id = Id;
  }

  String? get getName {
    return name;
  }

  void set setName(String? myName) {
    name = myName;
  }

  String? get getTel {
    return tel;
  }

  void set setTel(String? phone) {
    tel = phone;
  }

  String? get getAvataUrl {
    return id;
  }

  void set setAvataUrl(String? url) {
    avatarUrl = url;
  }

  String? get getResponse {
    return response;
  }

  void set setResponse(String? myResponse) {
    response = myResponse;
  }

}