class Promo {
  final int promoId;
  final String promoCode;
  final String description;
  final double discount;
  final String validUntil;

  Promo({
    required this.promoId,
    required this.promoCode,
    required this.description,
    required this.discount,
    required this.validUntil,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      promoId: json['promo_id'],
      promoCode: json['promo_code'],
      description: json['description'] ?? '',
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
      validUntil: json['valid_until'],
    );
  }
}