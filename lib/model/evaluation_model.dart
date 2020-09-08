// To parse this JSON data, do
//
//     final evaluationModel = evaluationModelFromJson(jsonString);

import 'dart:convert';

List<EvaluationModel> evaluationModelFromJson(String str) =>
    List<EvaluationModel>.from(
        json.decode(str).map((x) => EvaluationModel.fromJson(x)));

String evaluationModelToJson(List<EvaluationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EvaluationModel {
  EvaluationModel({
    this.eId,
    this.sex,
    this.type,
    this.age,
    this.e1,
    this.e2,
    this.e3,
    this.e4,
    this.e5,
    this.point,
  });

  String eId;
  String sex;
  String type;
  String age;
  String e1;
  String e2;
  String e3;
  String e4;
  String e5;
  String point;

  factory EvaluationModel.fromJson(Map<String, dynamic> json) =>
      EvaluationModel(
        eId: json["e_id"],
        sex: json["sex"],
        type: json["type"],
        age: json["age"],
        e1: json["e_1"],
        e2: json["e_2"],
        e3: json["e_3"],
        e4: json["e_4"],
        e5: json["e_5"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "e_id": eId,
        "sex": sex,
        "type": type,
        "age": age,
        "e_1": e1,
        "e_2": e2,
        "e_3": e3,
        "e_4": e4,
        "e_5": e5,
        "point": point,
      };
}
