enum PaymentMethod {
  pix('PIX'),
  cash('DINHEIRO'),
  card('CARTÃO'),
  boleto('BOLETO');

  const PaymentMethod(this.label);
  final String label;

  static PaymentMethod fromJson(String value) => switch (value.toUpperCase()) {
        'PIX' => PaymentMethod.pix,
        'DINHEIRO' => PaymentMethod.cash,
        'CARTÃO' || 'CARTAO' => PaymentMethod.card,
        'BOLETO' => PaymentMethod.boleto,
        _ => PaymentMethod.pix,
      };
}

class CaixaPosting {
  const CaixaPosting({
    required this.id,
    required this.memberName,
    required this.number,
    required this.paymentDate,
    required this.paymentMethod,
    required this.value,
  });

  final String id;
  final String memberName;
  final String number;
  final DateTime paymentDate;
  final PaymentMethod paymentMethod;
  final double value;

  factory CaixaPosting.fromJson(Map<String, dynamic> json) => CaixaPosting(
        id: json['id'] as String,
        memberName: json['member_name'] as String,
        number: json['number'] as String,
        paymentDate: DateTime.parse(json['payment_date'] as String),
        paymentMethod: PaymentMethod.fromJson(json['payment_method'] as String),
        value: (json['value'] as num).toDouble(),
      );
}

class CaixaFilter {
  const CaixaFilter({this.startDate, this.endDate, this.paymentMethod});

  final DateTime? startDate;
  final DateTime? endDate;
  final PaymentMethod? paymentMethod;
}
