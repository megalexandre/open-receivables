import 'package:organizagrana/shared/widgets/form/subcategory_dropdown.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.groupId,
    required this.waterMeter,
    required this.waterValue,
    required this.memberValue,
    this.descricao,
  });

  final String id;
  final String name;
  final int? groupId;
  final bool waterMeter;
  final double waterValue;
  final double memberValue;
  final String? descricao;

  String get subCategoryName => SubcategoryDropdown.items[groupId] ?? '';

  double get total => waterValue + memberValue;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] as String,
      groupId: json['group_id'] as int?,
      waterMeter: (json['has_hydrometer'] as bool?) ?? false,
      waterValue: (json['amount_water'] as num?)?.toDouble() ?? 0.0,
      memberValue: (json['amount_partner'] as num?)?.toDouble() ?? 0.0,
      descricao: json['descricao'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'group_id': groupId,
        'has_hydrometer': waterMeter,
        'amount_water': waterValue,
        'amount_partner': memberValue,
        'descricao': descricao,
      };

  Category copyWith({
    String? id,
    String? name,
    int? groupId,
    bool? waterMeter,
    double? waterValue,
    double? memberValue,
    String? descricao,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      groupId: groupId ?? this.groupId,
      waterMeter: waterMeter ?? this.waterMeter,
      waterValue: waterValue ?? this.waterValue,
      memberValue: memberValue ?? this.memberValue,
      descricao: descricao ?? this.descricao,
    );
  }
}
