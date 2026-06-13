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
    this.number,
    this.registrationDate,
    required this.partnerExclusive,
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
  final String? number;
  final DateTime? registrationDate;
  final bool partnerExclusive;

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
        id: json['id'].toString(),
        memberId: json['memberId']?.toString() ?? '',
        memberName: json['memberName'] as String,
        addressId: json['addressId']?.toString() ?? '',
        address: json['address'] as String,
        active: json['active'] as bool,
        categoryId: json['categoryId']?.toString() ?? '',
        categoryName: json['categoryName'] as String,
        value: (json['value'] as num).toDouble(),
        number: json['number'] as String?,
        registrationDate: json['registrationDate'] != null
            ? DateTime.tryParse(json['registrationDate'].toString())
            : null,
        partnerExclusive: json['partnerExclusive'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        if (id.isNotEmpty) 'id': id,
        'member_id': memberId,
        'address_id': addressId,
        'category_id': categoryId,
        if (number != null && number!.isNotEmpty) 'number': number,
        if (registrationDate != null)
          'registration_date': registrationDate!.toIso8601String().split('T').first,
        'partner_exclusive': partnerExclusive,
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
    String? number,
    DateTime? registrationDate,
    bool? partnerExclusive,
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
        number: number ?? this.number,
        registrationDate: registrationDate ?? this.registrationDate,
        partnerExclusive: partnerExclusive ?? this.partnerExclusive,
      );
}
