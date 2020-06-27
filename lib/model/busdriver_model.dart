// To parse this JSON data, do
//
//     final busdriverModel = busdriverModelFromJson(jsonString);

import 'dart:convert';

List<BusdriverModel> busdriverModelFromJson(String str) => List<BusdriverModel>.from(json.decode(str).map((x) => BusdriverModel.fromJson(x)));

String busdriverModelToJson(List<BusdriverModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
        this.dImage,
    });

    String did;
    String dUsername;
    String dPassword;
    String dName;
    String dSex;
    String bdDate;
    String dTell;
    String dEmail;
    String dImage;

    factory BusdriverModel.fromJson(Map<String, dynamic> json) => BusdriverModel(
        did: json["Did"],
        dUsername: json["d_username"],
        dPassword: json["d_password"],
        dName: json["d_name"],
        dSex: json["d_sex"],
        bdDate: json["bd_Date"],
        dTell: json["d_tell"],
        dEmail: json["d_email"],
        dImage: json["d_image"],
    );

    Map<String, dynamic> toJson() => {
        "Did": did,
        "d_username": dUsername,
        "d_password": dPassword,
        "d_name": dName,
        "d_sex": dSex,
        "bd_Date": bdDate,
        "d_tell": dTell,
        "d_email": dEmail,
        "d_image": dImage,
    };
}
