// To parse this JSON data, do
//
//     final busModel = busModelFromJson(jsonString);

import 'dart:convert';

List<BusModel> busModelFromJson(String str) =>
    List<BusModel>.from(json.decode(str).map((x) => BusModel.fromJson(x)));

String busModelToJson(List<BusModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusModel {
  BusModel({
    this.cId,
    this.cid,
    this.did,
    this.cStatus,
  });

  String cId;
  String cid;
  String did;
  String cStatus;

  factory BusModel.fromJson(Map<String, dynamic> json) => BusModel(
        cId: json["c_id"],
        cid: json["Cid"],
        did: json["Did"],
        cStatus: json["c_status"],
      );

  Map<String, dynamic> toJson() => {
        "c_id": cId,
        "Cid": cid,
        "Did": did,
        "c_status": cStatus,
      };
}
