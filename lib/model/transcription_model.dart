// To parse this JSON data, do
//
//     final transcriptionModel = transcriptionModelFromJson(jsonString);

import 'dart:convert';

List<TranscriptionModel> transcriptionModelFromJson(String str) =>
    List<TranscriptionModel>.from(
        json.decode(str).map((x) => TranscriptionModel.fromJson(x)));

String transcriptionModelToJson(List<TranscriptionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TranscriptionModel {
  TranscriptionModel({
    this.tId,
    this.tAid,
    this.tType,
    this.tDatetime,
  });

  String tId;
  String tAid;
  String tType;
  String tDatetime;

  factory TranscriptionModel.fromJson(Map<String, dynamic> json) =>
      TranscriptionModel(
        tId: json["t_id"],
        tAid: json["t_Aid"],
        tType: json["t_type"],
        tDatetime: json["t_datetime"],
      );

  Map<String, dynamic> toJson() => {
        "t_id": tId,
        "t_Aid": tAid,
        "t_type": tType,
        "t_datetime": tDatetime,
      };
}
