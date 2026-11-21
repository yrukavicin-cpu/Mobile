class User {
  final String id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  // перші букви імені і прізвища для аватарки
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  User copyWith({String? name, String? email}) {
    return User(id: id, name: name ?? this.name, email: email ?? this.email);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name'], email: json['email']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}
