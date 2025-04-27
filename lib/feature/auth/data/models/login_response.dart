class LoginResponse {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String role;
  final String token;

  LoginResponse({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      token: json['token'],
    );
  }
}
