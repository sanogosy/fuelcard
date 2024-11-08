class Operation {
  int? id;
  int? operateur_id;
  int? montant;
  int? pourcentage_reduction;
  int? reduction;
  String? date;
  String? type_compte_initiateur;
  int? transfered;

  Operation({
    this.id,
    this.operateur_id,
    this.montant,
    this.pourcentage_reduction,
    this.reduction,
    this.date,
    this.type_compte_initiateur,
    this.transfered,
  });

  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
        id: json['id'],
        operateur_id: json['operateur_id'],
        montant: json['montant'],
        pourcentage_reduction: json['pourcentage_reduction'],
        reduction: json['reduction'],
        date: json['date'] as String,
        type_compte_initiateur: json['type_compte_initiateur'] as String,
        transfered: json['transfered'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'operateur_id': operateur_id,
      'montant': montant,
      'pourcentage_reduction': pourcentage_reduction,
      'reduction': reduction,
      'date': date,
      'type_compte_initiateur': type_compte_initiateur,
      'transfered': transfered,
    };

    return map;
  }
}