class Connection {
  const Connection({
    required this.id,
    required this.memberName,
    required this.address,
    required this.active,
    required this.categoryName,
    required this.value,
  });

  final String id;
  final String memberName;
  final String address;
  final bool active;
  final String categoryName;
  final double value;

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
        id: json['id'] as String,
        memberName: json['member_name'] as String,
        address: json['address'] as String,
        active: json['active'] as bool,
        categoryName: json['category_name'] as String,
        value: (json['value'] as num).toDouble(),
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
