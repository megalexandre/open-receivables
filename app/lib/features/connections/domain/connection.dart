class Connection {
  const Connection({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.addressId,
    required this.address,
    required this.active,
    required this.categoryId,
    required this.categoryName,
    required this.value,
    this.numero,
    this.datamatricula,
    required this.exclusiveMember,
  });

  final String id;
  final String memberId;
  final String memberName;
  final String addressId;
  final String address;
  final bool active;
  final String categoryId;
  final String categoryName;
  final double value;
  final String? numero;
  final DateTime? datamatricula;
  final bool exclusiveMember;

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
        id: json['id'] as String,
        memberId: json['member_id'] as String? ?? '',
        memberName: json['member_name'] as String,
        addressId: json['address_id'] as String? ?? '',
        address: json['address'] as String,
        active: json['active'] as bool,
        categoryId: json['category_id'] as String? ?? '',
        categoryName: json['category_name'] as String,
        value: (json['value'] as num).toDouble(),
        numero: json['numero'] as String?,
        datamatricula: json['datamatricula'] != null
            ? DateTime.tryParse(json['datamatricula'].toString())
            : null,
        exclusiveMember: json['socio_exclusivo'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        if (id.isNotEmpty) 'id': id,
        'id_pessoa': memberId,
        'address_id': addressId,
        'id_categoria_socio': categoryId,
        if (numero != null && numero!.isNotEmpty) 'numero': numero,
        if (datamatricula != null)
          'datamatricula': datamatricula!.toIso8601String().split('T').first,
        'inativo': active ? '\x00' : '\x01',
        'socio_exclusivo': exclusiveMember ? '\x01' : '\x00',
      };

  Connection copyWith({
    String? id,
    String? memberId,
    String? memberName,
    String? addressId,
    String? address,
    bool? active,
    String? categoryId,
    String? categoryName,
    double? value,
    String? numero,
    DateTime? datamatricula,
    bool? exclusiveMember,
  }) =>
      Connection(
        id: id ?? this.id,
        memberId: memberId ?? this.memberId,
        memberName: memberName ?? this.memberName,
        addressId: addressId ?? this.addressId,
        address: address ?? this.address,
        active: active ?? this.active,
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        value: value ?? this.value,
        numero: numero ?? this.numero,
        datamatricula: datamatricula ?? this.datamatricula,
        exclusiveMember: exclusiveMember ?? this.exclusiveMember,
      );
}

class ConnectionSummary {
  const ConnectionSummary({
    required this.total,
    required this.active,
    required this.effective,
    required this.temporary,
  });

  final int total;
  final int active;
  final int effective;
  final int temporary;

  factory ConnectionSummary.fromJson(Map<String, dynamic> json) =>
      ConnectionSummary(
        total: json['total'] as int,
        active: json['active'] as int,
        effective: json['effective'] as int,
        temporary: json['temporary'] as int,
      );
}
