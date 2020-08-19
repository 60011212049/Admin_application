import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/evaluation_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class PageEvaluation extends StatefulWidget {
  @override
  _PageEvaluationState createState() => _PageEvaluationState();
}

class _PageEvaluationState extends State<PageEvaluation> {
  List<EvaluationModel> evaluation = List<EvaluationModel>();
  List<EvaluationModel> evaluationForSearch = List<EvaluationModel>();
  TextEditingController editcontroller = TextEditingController();
  bool loading = false;
  int i = 0;
  @override
  void initState() {
    super.initState();
    getDataEvaluation();
    this.i = 0;
  }

  @override
  void dispose() {
    super.dispose();
    this.i = 0;
  }

  int countRound() {
    i = i + 1;
    return i;
  }

  Future<Null> getDataEvaluation() async {
    var status = {};
    status['status'] = 'show';
    status['id'] = '';
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/evaluation_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    evaluation = jsonData.map((i) => EvaluationModel.fromJson(i)).toList();
    evaluationForSearch.addAll(evaluation);
    this.i = 0;
    loading = true;
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<EvaluationModel> dummySearchList = List<EvaluationModel>();
    dummySearchList.addAll(evaluation);
    if (query.isNotEmpty) {
      List<EvaluationModel> dummyListData = List<EvaluationModel>();
      dummySearchList.forEach((item) {
        if ((item.type.toLowerCase()).contains(query) ||
            (item.point.toLowerCase()).contains(query) ||
            (item.sex.toLowerCase()).contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        evaluationForSearch.clear();
        evaluationForSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        evaluationForSearch.clear();
        evaluationForSearch.addAll(evaluation);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ผลการประเมิน',
          style: TextStyle(
            color: Color(0xFF3a3a3a),
            fontSize: ScreenUtil().setSp(60),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => AddBusSchedule(),
              //     )).then((value) {
              //   this.i = 0;
              //   getDataBusSchedule();
              // });
            },
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: TextField(
                onChanged: (value) {
                  this.i = 0;
                  filterSearchResults(value);
                },
                controller: editcontroller,
                decoration: InputDecoration(
                    labelText: "ค้นหา",
                    labelStyle: TextStyle(fontSize: ScreenUtil().setSp(50)),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Container(
              child: Center(
                child: Center(
                  child: DataTable(
                    columnSpacing: ScreenUtil().setWidth(0),
                    showCheckboxColumn: true,
                    sortAscending: true,
                    sortColumnIndex: 1,
                    columns: [
                      DataColumn(
                        label: textColumn('เพศ'),
                      ),
                      DataColumn(
                        label: textColumn('ผู้ใช้งาน'),
                      ),
                      DataColumn(
                        label: textColumn('ข้อที่1'),
                      ),
                      DataColumn(
                        label: textColumn('ข้อที่2'),
                      ),
                      DataColumn(
                        label: textColumn('ข้อที่3'),
                      ),
                      DataColumn(
                        label: textColumn('ข้อที่4'),
                      ),
                      DataColumn(
                        label: textColumn('ข้อที่5'),
                      ),
                      DataColumn(
                        label: textColumPoint('คะแนนรวม'),
                      ),
                    ],
                    rows: (loading == true)
                        ? evaluationForSearch
                            .map(
                              (data) => DataRow(cells: [
                                buildDataCellPoint(data.sex),
                                buildDataCell(data.type),
                                buildDataCellPoint(data.e1),
                                buildDataCellPoint(data.e2),
                                buildDataCellPoint(data.e3),
                                buildDataCellPoint(data.e4),
                                buildDataCellPoint(data.e5),
                                buildDataCell(data.point),
                              ]),
                            )
                            .toList()
                        : [
                            DataRow(
                              cells: [
                                buildDataCell(''),
                                buildDataCell(''),
                                buildDataCell(''),
                                buildDataCell(''),
                                buildDataCell(''),
                                buildDataCell(''),
                                buildDataCell(''),
                                buildDataCell(''),
                              ],
                            ),
                          ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataCell buildDataCell(String text) {
    return DataCell(
      Container(
        width: ScreenUtil().setWidth(130),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(40),
              fontFamily: 'Quark',
            ),
          ),
        ),
      ),
    );
  }

  DataCell buildDataCellPoint(String text) {
    return DataCell(
      Container(
        width: ScreenUtil().setWidth(100),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(40),
              fontFamily: 'Quark',
            ),
          ),
        ),
      ),
    );
  }

  Container textColumn(String data) {
    return Container(
      width: ScreenUtil().setWidth(120),
      child: Text(
        data,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(40),
          fontFamily: 'Quark',
          color: Color(0xFF3a3a3a),
        ),
      ),
    );
  }

  Container textColumPoint(String data) {
    return Container(
      width: ScreenUtil().setWidth(140),
      child: Text(
        data,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(40),
          fontFamily: 'Quark',
          color: Color(0xFF3a3a3a),
        ),
      ),
    );
  }
}
