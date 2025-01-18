// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String password;
  final String email;
  final String mobile;
  final String role;
  final bool isBlocked;
  final List<String> cart;
  final List<String> address;
  final List<String> wishlist;
  final String? refreshToken;
  final String? token;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.email,
    required this.mobile,
    required this.role,
    required this.isBlocked,
    required this.cart,
    required this.address,
    required this.wishlist,
    this.refreshToken,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'email': email,
      'mobile': mobile,
      'role': role,
      'isBlocked': isBlocked,
      'cart': cart,
      'address': address,
      'wishlist': wishlist,
      'refreshToken': refreshToken,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      password: map['password'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'] ?? '',
      role: map['role'] ?? 'user',
      isBlocked: map['isBlocked'] ?? false,
      cart: List<String>.from(map['cart'] ?? []),
      address: List<String>.from(map['address'] ?? []),
      wishlist: List<String>.from(map['wishlist'] ?? []),
      refreshToken: map['refreshToken'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? password,
    String? email,
    String? mobile,
    String? role,
    bool? isBlocked,
    List<String>? cart,
    List<String>? address,
    List<String>? wishlist,
    String? refreshToken,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      isBlocked: isBlocked ?? this.isBlocked,
      cart: cart ?? this.cart,
      address: address ?? this.address,
      wishlist: wishlist ?? this.wishlist,
      refreshToken: refreshToken ?? this.refreshToken,
      token: token ?? this.token,
    );
  }
}
