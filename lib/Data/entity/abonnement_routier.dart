class AbonnementRoutier {
  final String? response;
  final String? message;
  final String? dateDernierAbonnement;
  final int? nombreJourRestant;

  AbonnementRoutier({
    this.response,
    this.message,
    this.dateDernierAbonnement,
    this.nombreJourRestant
  });

  factory AbonnementRoutier.fromMap(Map<String, dynamic> userData) {
    return AbonnementRoutier(
        response: userData['response'],
        message: userData['message'],
        dateDernierAbonnement: userData['dateDernierAbonnement'],
        nombreJourRestant: userData['nombreJourRestant']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'response': response,
      'message': message,
      'dateDernierAbonnement': dateDernierAbonnement,
      'nombreJourRestant': nombreJourRestant
    };
  }

  factory AbonnementRoutier.fromJson(Map<String, dynamic> json) => AbonnementRoutier(
      response: json['response'],
      message: json['message'],
      dateDernierAbonnement: json['dateDernierAbonnement'],
      nombreJourRestant: json['nombreJourRestant']
  );

}