// To parse this JSON data, do
//
//     final outSideBusModel = outSideBusModelFromJson(jsonString);

import 'dart:convert';

List<OutSideBusModel> outSideBusModelFromJson(String str) =>
    List<OutSideBusModel>.from(
        json.decode(str).map((x) => OutSideBusModel.fromJson(x)));

String outSideBusModelToJson(List<OutSideBusModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OutSideBusModel {
  OutSideBusModel({
    this.did,
    this.cid,
    this.outLatitude,
    this.outLongitude,
    this.outDate,
  });

  String did;
  String cid;
  String outLatitude;
  String outLongitude;
  DateTime outDate;

  factory OutSideBusModel.fromJson(Map<String, dynamic> json) =>
      OutSideBusModel(
        did: json["Did"],
        cid: json["Cid"],
        outLatitude: json["out_latitude"],
        outLongitude: json["out_longitude"],
        outDate: DateTime.parse(json["Out_date"]),
      );

  Map<String, dynamic> toJson() => {
        "Did": did,
        "Cid": cid,
        "out_latitude": outLatitude,
        "out_longitude": outLongitude,
        "Out_date": outDate.toIso8601String(),
      };
}
