class Address {
  const Address({
    required this.id,
    required this.addressType,
    required this.name,
    this.notes,
  });

  final String id;
  final String addressType;
  final String name;
  final String? notes;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['id'].toString(),
        addressType: (json['address_type'] as String?) ?? '',
        name: json['name'] as String,
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'address_type': addressType,
        'name': name,
        if (notes != null) 'notes': notes,
      };

  Address copyWith({
    String? id,
    String? addressType,
    String? name,
    String? notes,
  }) =>
      Address(
        id: id ?? this.id,
        addressType: addressType ?? this.addressType,
        name: name ?? this.name,
        notes: notes ?? this.notes,
      );
}
