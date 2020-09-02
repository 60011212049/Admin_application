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
    this.idStwork,
    this.did,
    this.inDate,
    this.outDate,
    this.inSid,
    this.outSid,
  });

  String idStwork;
  String did;
  DateTime inDate;
  DateTime outDate;
  String inSid;
  String outSid;

  factory StatusWorkModel.fromJson(Map<String, dynamic> json) =>
      StatusWorkModel(
        idStwork: json["id_stwork"],
        did: json["Did"],
        inDate: DateTime.parse(json["in_date"]),
        outDate: DateTime.parse(json["out_date"]),
        inSid: json["in_Sid"],
        outSid: json["out_Sid"],
      );

  Map<String, dynamic> toJson() => {
        "id_stwork": idStwork,
        "Did": did,
        "in_date": inDate.toIso8601String(),
        "out_date": outDate.toIso8601String(),
        "in_Sid": inSid,
        "out_Sid": outSid,
      };
}
