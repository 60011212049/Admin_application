// To parse this JSON data, do
//
//     final adminModel = adminModelFromJson(jsonString);

import 'dart:convert';

List<AdminModel> adminModelFromJson(String str) =>
    List<AdminModel>.from(json.decode(str).map((x) => AdminModel.fromJson(x)));

String adminModelToJson(List<AdminModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdminModel {
  AdminModel({
    this.aid,
    this.username,
    this.password,
    this.tell,
    this.email,
    this.aStatus,
  });

  String aid;
  String username;
  String password;
  String tell;
  String email;
  String aStatus;

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        aid: json["Aid"],
        username: json["username"],
        password: json["password"],
        tell: json["tell"],
        email: json["email"],
        aStatus: json["a_status"],
      );

  Map<String, dynamic> toJson() => {
        "Aid": aid,
        "username": username,
        "password": password,
        "tell": tell,
        "email": email,
        "a_status": aStatus,
      };
}
