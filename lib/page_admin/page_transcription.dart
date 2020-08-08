import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/busschedule_model.dart';
import 'package:adminapp/model/transcription_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class Transcription extends StatefulWidget {
  @override
  _TranscriptionState createState() => _TranscriptionState();
}

class _TranscriptionState extends State<Transcription> {
  List<TranscriptionModel> tran = List<TranscriptionModel>();
  var status = {};
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getDataBusSchedule();
  }

  Future<Null> getDataBusSchedule() async {
    status['status'] = 'show';
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/transcription_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    tran = jsonData.map((i) => TranscriptionModel.fromJson(i)).toList();
    loading = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'ประวัติการใช้งาน',
            style: TextStyle(
              color: Color(0xFF3a3a3a),
              fontSize: ScreenUtil().setSp(60),
            ),
          ),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                child: Center(
                  child: DataTable(
                      columnSpacing: ScreenUtil().setSp(80),
                      sortColumnIndex: 1,
                      columns: [
                        DataColumn(
                          label: textColumn('ผู้ดูแล'),
                        ),
                        DataColumn(
                          label: textColumn('งานที่ทำ'),
                        ),
                        DataColumn(
                          label: textColumn('เวลา'),
                        ),
                      ],
                      rows: (loading == true)
                          ? tran
                              .map(
                                (data) => DataRow(
                                  cells: [
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(50),
                                        child: Text(
                                          data.tAid,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(40),
                                            fontFamily: 'Quark',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(400),
                                        child: Text(
                                          data.tType,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(42),
                                            fontFamily: 'Quark',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(250),
                                        child: Text(
                                          data.tDatetime,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(40),
                                            fontFamily: 'Quark',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList()
                          : [
                              DataRow(
                                cells: [
                                  DataCell(
                                    Container(
                                      width: ScreenUtil().setWidth(50),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(40),
                                          fontFamily: 'Quark',
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: ScreenUtil().setWidth(400),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(42),
                                          fontFamily: 'Quark',
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: ScreenUtil().setWidth(250),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(40),
                                          fontFamily: 'Quark',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                ),
              ),
            ],
          ),
        ));
  }

  Text textColumn(String data) {
    return Text(
      data,
      style: TextStyle(
        fontSize: ScreenUtil().setSp(60),
        fontFamily: 'Quark',
        color: Color(0xFF3a3a3a),
      ),
    );
  }
}
