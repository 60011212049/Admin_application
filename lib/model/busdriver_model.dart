// To parse this JSON data, do
//
//     final busdriverModel = busdriverModelFromJson(jsonString);

import 'dart:convert';

List<BusdriverModel> busdriverModelFromJson(String str) =>
    List<BusdriverModel>.from(
        json.decode(str).map((x) => BusdriverModel.fromJson(x)));

String busdriverModelToJson(List<BusdriverModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusdriverModel {
  BusdriverModel({
    this.did,
    this.dUsername,
    this.dPassword,
    this.dName,
    this.dSex,
    this.bdDate,
    this.dTell,
    this.dEmail,
    this.cId,
    this.dImage,
    this.dStatus,
  });

  String did;
  String dUsername;
  String dPassword;
  String dName;
  String dSex;
  DateTime bdDate;
  String dTell;
  String dEmail;
  String cId;
  String dImage;
  String dStatus;

  factory BusdriverModel.fromJson(Map<String, dynamic> json) => BusdriverModel(
        did: json["Did"],
        dUsername: json["d_username"],
        dPassword: json["d_password"],
        dName: json["d_name"],
        dSex: json["d_sex"],
        bdDate: DateTime.parse(json["bd_Date"]),
        dTell: json["d_tell"],
        dEmail: json["d_email"],
        cId: json["CId"],
        dImage: json["d_image"],
        dStatus: json["d_status"],
      );

  Map<String, dynamic> toJson() => {
        "Did": did,
        "d_username": dUsername,
        "d_password": dPassword,
        "d_name": dName,
        "d_sex": dSex,
        "bd_Date":
            "${bdDate.year.toString().padLeft(4, '0')}-${bdDate.month.toString().padLeft(2, '0')}-${bdDate.day.toString().padLeft(2, '0')}",
        "d_tell": dTell,
        "d_email": dEmail,
        "CId": cId,
        "d_image": dImage,
        "d_status": dStatus,
      };
}
