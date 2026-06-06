
class Address {
  const Address({
    required this.id,
    required this.type,
    required this.name,
    required this.baseCep,
    this.notes,
  });

  final String id;
  final String type;
  final String name;
  final String baseCep;
  final String? notes;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['id'] as String,
        type: json['type'] as String,
        name: json['name'] as String,
        baseCep: json['base_cep'] as String,
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'name': name,
        'base_cep': baseCep,
        if (notes != null) 'notes': notes,
      };

  Address copyWith({
    String? id,
    String? type,
    String? name,
    String? baseCep,
    String? notes,
  }) =>
      Address(
        id: id ?? this.id,
        type: type ?? this.type,
        name: name ?? this.name,
        baseCep: baseCep ?? this.baseCep,
        notes: notes ?? this.notes,
      );
}
