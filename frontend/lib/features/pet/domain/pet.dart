class Pet {
  const Pet({
    required this.id,
    required this.name,
    this.profileImageUrl,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'].toString(),
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  final String id;
  final String name;
  final String? profileImageUrl;
}