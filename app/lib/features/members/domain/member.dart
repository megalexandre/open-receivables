class Member {
  const Member({
    required this.id,
    required this.name,
    required this.document,
    this.memberNumber,
    this.voter = false,
    this.active = true,
  });

  final String id;
  final String name;
  final String document;
  final int? memberNumber;
  final bool voter;
  final bool active;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'].toString(),
        name: json['name'] as String,
        document: json['document'] as String,
        memberNumber: (json['member_number'] as num?)?.toInt(),
        voter: json['voter'] as bool? ?? false,
        active: json['active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'document': document,
        'member_number': memberNumber,
        'voter': voter,
      };

  Member copyWith({
    String? id,
    String? name,
    String? document,
    int? memberNumber,
    bool? voter,
    bool? active,
  }) =>
      Member(
        id: id ?? this.id,
        name: name ?? this.name,
        document: document ?? this.document,
        memberNumber: memberNumber ?? this.memberNumber,
        voter: voter ?? this.voter,
        active: active ?? this.active,
      );
}
