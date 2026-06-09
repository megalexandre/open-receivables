enum BoletoStatus { paga, aberta, cancelada }

extension BoletoStatusExt on BoletoStatus {
  String get label => switch (this) {
        BoletoStatus.paga => 'Paga',
        BoletoStatus.aberta => 'Aberta',
        BoletoStatus.cancelada => 'Cancelada',
      };

  static BoletoStatus fromString(String v) => switch (v.toLowerCase()) {
        'paga' => BoletoStatus.paga,
        'aberta' => BoletoStatus.aberta,
        _ => BoletoStatus.cancelada,
      };
}

class BoletoFilter {
  const BoletoFilter({
    this.number,
    this.memberSearch,
    this.status,
    this.addressSearch,
    this.competencia,
    this.vencimento,
  });

  final String? number;
  final String? memberSearch;
  final BoletoStatus? status;
  final String? addressSearch;
  final String? competencia;
  final String? vencimento;

  Map<String, String> toQueryParams() => {
        if (number != null && number!.isNotEmpty) 'number': number!,
        if (memberSearch != null && memberSearch!.isNotEmpty) 'member': memberSearch!,
        if (status != null) 'status': status!.name,
        if (addressSearch != null && addressSearch!.isNotEmpty) 'address': addressSearch!,
        if (competencia != null && competencia!.isNotEmpty) 'competencia': competencia!,
        if (vencimento != null && vencimento!.isNotEmpty) 'vencimento': vencimento!,
      };
}

class Boleto {
  const Boleto({
    required this.id,
    required this.number,
    required this.memberName,
    required this.address,
    required this.competencia,
    required this.valorTotal,
    required this.vencimento,
    required this.status,
  });

  final String id;
  final String number;
  final String memberName;
  final String address;
  final String competencia;
  final double valorTotal;
  final String vencimento;
  final BoletoStatus status;

  factory Boleto.fromJson(Map<String, dynamic> json) => Boleto(
        id: json['id'] as String,
        number: json['number'] as String,
        memberName: json['member_name'] as String,
        address: json['address'] as String,
        competencia: json['competencia'] as String,
        valorTotal: (json['valor_total'] as num).toDouble(),
        vencimento: json['vencimento'] as String,
        status: BoletoStatusExt.fromString(json['status'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'member_name': memberName,
        'address': address,
        'competencia': competencia,
        'valor_total': valorTotal,
        'vencimento': vencimento,
        'status': status.name,
      };
}
