// To parse this JSON data, do
//
//     final assesmentModel = assesmentModelFromJson(jsonString);

import 'dart:convert';

List<AssesmentModel> assesmentModelFromJson(String str) =>
    List<AssesmentModel>.from(
        json.decode(str).map((x) => AssesmentModel.fromJson(x)));

String assesmentModelToJson(List<AssesmentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AssesmentModel {
  AssesmentModel({
    this.aId,
    this.aDetail,
    this.aPoint,
  });

  String aId;
  String aDetail;
  String aPoint;

  factory AssesmentModel.fromJson(Map<String, dynamic> json) => AssesmentModel(
        aId: json["a_id"],
        aDetail: json["a_detail"],
        aPoint: json["a_point"],
      );

  Map<String, dynamic> toJson() => {
        "a_id": aId,
        "a_detail": aDetail,
        "a_point": aPoint,
      };
}
