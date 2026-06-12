class Category {
  const Category({
    required this.id,
    required this.name,
    required this.memberType,
    required this.waterMeter,
    required this.waterValue,
    required this.memberValue,
    this.descricao,
    this.active = true,
  });

  static const memberTypes = [
    'Sócio Fundador',
    'Sócio Efetivo',
    'Sócio Temporário',
  ];

  final String id;
  final String name;
  final String? memberType;
  final bool waterMeter;
  final double waterValue;
  final double memberValue;
  final String? descricao;
  final bool active;

  double get total => waterValue + memberValue;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'].toString(),
        name: json['name'] as String,
        memberType: json['member_type'] as String?,
        waterMeter: (json['has_hydrometer'] as bool?) ?? false,
        waterValue: (json['amount_water'] as num?)?.toDouble() ?? 0.0,
        memberValue: (json['amount_partner'] as num?)?.toDouble() ?? 0.0,
        descricao: json['descricao'] as String?,
        active: json['active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'member_type': memberType,
        'has_hydrometer': waterMeter,
        'amount_water': waterValue,
        'amount_partner': memberValue,
        'descricao': descricao,
      };

  Category copyWith({
    String? id,
    String? name,
    String? memberType,
    bool? waterMeter,
    double? waterValue,
    double? memberValue,
    String? descricao,
    bool? active,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        memberType: memberType ?? this.memberType,
        waterMeter: waterMeter ?? this.waterMeter,
        waterValue: waterValue ?? this.waterValue,
        memberValue: memberValue ?? this.memberValue,
        descricao: descricao ?? this.descricao,
        active: active ?? this.active,
      );
}
