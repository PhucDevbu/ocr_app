class UserApp {
  final String email;
  final String name;
  final String uId;


  UserApp({required this.email, required this.name, required this.uId});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'uId': uId,
    };
  }

  static UserApp fromMap(Map<String, dynamic> map) {
    return UserApp(
        email: map['email'], name: map['name'], uId: map['uId']);
  }
}