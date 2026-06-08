class Member {
  const Member({
    required this.id,
    required this.memberNumber,
    required this.name,
    required this.document,
  });

  final String id;
  final String memberNumber;
  final String name;
  final String document;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'].toString(),
        memberNumber: json['member_number']?.toString() ?? '',
        name: json['name'] as String,
        document: json['document'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'member_number': memberNumber,
        'name': name,
        'document': document,
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
      );
}
