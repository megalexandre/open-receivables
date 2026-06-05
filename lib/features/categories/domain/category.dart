class Category {
  const Category({
    required this.id,
    required this.name,
    required this.group,
    required this.waterMeter,
    required this.waterValue,
    required this.memberValue,
  });

  final String id;
  final String name;
  final String group;
  final bool waterMeter;
  final double waterValue;
  final double memberValue;

  double get total => waterValue + memberValue;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      group: json['group'] as String,
      waterMeter: json['water_meter'] as bool,
      waterValue: (json['water_value'] as num).toDouble(),
      memberValue: (json['member_value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'group': group,
        'water_meter': waterMeter,
        'water_value': waterValue,
        'member_value': memberValue,
      };

  Category copyWith({
    String? id,
    String? name,
    String? group,
    bool? waterMeter,
    double? waterValue,
    double? memberValue,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      group: group ?? this.group,
      waterMeter: waterMeter ?? this.waterMeter,
      waterValue: waterValue ?? this.waterValue,
      memberValue: memberValue ?? this.memberValue,
    );
  }
}
