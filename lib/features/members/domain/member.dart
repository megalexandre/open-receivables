class Member {
  const Member({
    required this.id,
    required this.memberNumber,
    required this.name,
    required this.document,
    required this.active,
  });

  final String id;
  final String memberNumber;
  final String name;
  final String document;
  final bool active;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'] as String,
        memberNumber: json['member_number'] as String,
        name: json['name'] as String,
        document: json['document'] as String,
        active: json['active'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'member_number': memberNumber,
        'name': name,
        'document': document,
        'active': active,
      };

  Member copyWith({
    String? id,
    String? memberNumber,
    String? name,
    String? document,
    bool? active,
  }) =>
      Member(
        id: id ?? this.id,
        memberNumber: memberNumber ?? this.memberNumber,
        name: name ?? this.name,
        document: document ?? this.document,
        active: active ?? this.active,
      );
}
