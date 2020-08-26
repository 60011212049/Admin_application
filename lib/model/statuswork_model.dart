// To parse this JSON data, do
//
//     final statusWorkModel = statusWorkModelFromJson(jsonString);

import 'dart:convert';

List<StatusWorkModel> statusWorkModelFromJson(String str) =>
    List<StatusWorkModel>.from(
        json.decode(str).map((x) => StatusWorkModel.fromJson(x)));

String statusWorkModelToJson(List<StatusWorkModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatusWorkModel {
  StatusWorkModel({
    this.did,
    this.inDate,
    this.outDate,
    this.inSid,
    this.outSid,
  });

  String did;
  String inDate;
  String outDate;
  String inSid;
  String outSid;

  factory StatusWorkModel.fromJson(Map<String, dynamic> json) =>
      StatusWorkModel(
        did: json["Did"],
        inDate: json["in_date"],
        outDate: json["out_date"],
        inSid: json["in_Sid"],
        outSid: json["out_Sid"],
      );

  Map<String, dynamic> toJson() => {
        "Did": did,
        "in_date": inDate,
        "out_date": outDate,
        "in_Sid": inSid,
        "out_Sid": outSid,
      };
}
