class InvoiceCandidate {
  const InvoiceCandidate({
    required this.id,
    required this.memberName,
    required this.address,
    required this.category,
    required this.valorTotal,
    required this.hdrInicial,
  });

  final String id;
  final String memberName;
  final String address;
  final String category;
  final double valorTotal;
  final double hdrInicial;

  factory InvoiceCandidate.fromJson(Map<String, dynamic> json) =>
      InvoiceCandidate(
        id: json['id'] as String,
        memberName: json['member_name'] as String,
        address: json['address'] as String,
        category: json['category'] as String,
        valorTotal: (json['valor_total'] as num).toDouble(),
        hdrInicial: (json['hdr_inicial'] as num).toDouble(),
      );
}

class InvoiceCandidateFilter {
  const InvoiceCandidateFilter({
    this.meterType,
    this.competencia,
    this.addressId,
  });

  final String? meterType;
  final String? competencia;
  final String? addressId;

  Map<String, String> toQueryParams() => {
        if (meterType != null && meterType != 'Todos') 'meterType': meterType!,
        if (competencia != null && competencia!.isNotEmpty)
          'competencia': competencia!,
        'addressId': ?addressId,
      };
}

class GenerateInvoicesRequest {
  const GenerateInvoicesRequest({
    required this.candidateIds,
    required this.dueDate,
  });

  final List<String> candidateIds;
  final String dueDate;

  Map<String, dynamic> toJson() => {
        'candidate_ids': candidateIds,
        'due_date': dueDate,
      };
}
