import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/statuswork_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class ManageStatusWork extends StatefulWidget {
  @override
  _ManageStatusWorkState createState() => _ManageStatusWorkState();
}

class _ManageStatusWorkState extends State<ManageStatusWork> {
  List<StatusWorkModel> stWork = List<StatusWorkModel>();
  var status = {};
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getDataStatusWork();
  }

  Future<Null> getDataStatusWork() async {
    status['status'] = 'show';
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/statuswork_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    stWork = jsonData.map((i) => StatusWorkModel.fromJson(i)).toList();
    loading = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'ตรวจสอบรถออกนอกจุด',
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
                      columnSpacing: ScreenUtil().setSp(10),
                      sortColumnIndex: 1,
                      columns: [
                        DataColumn(
                          label: textColumn('รหัสคนขับ'),
                        ),
                        DataColumn(
                          label: textColumn('เข้าเวลา'),
                        ),
                        DataColumn(
                          label: textColumn('ออกเวลา'),
                        ),
                        DataColumn(
                          label: textColumn('เข้าจุด'),
                        ),
                        DataColumn(
                          label: textColumn('ออกจุด'),
                        ),
                      ],
                      rows: (loading == true)
                          ? stWork
                              .map(
                                (data) => DataRow(
                                  cells: [
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(200),
                                        child: Text(
                                          data.did,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(30),
                                            fontFamily: 'Quark',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(250),
                                        child: Text(
                                          data.inDate,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(33),
                                            fontFamily: 'Quark',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(250),
                                        child: Text(
                                          data.outDate,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(33),
                                            fontFamily: 'Quark',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(130),
                                        child: Text(
                                          data.outSid,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(33),
                                            fontFamily: 'Quark',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(50),
                                        child: Text(
                                          data.outSid,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(33),
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
                                      width: ScreenUtil().setWidth(200),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
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
                                          fontSize: ScreenUtil().setSp(33),
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
                                          fontSize: ScreenUtil().setSp(33),
                                          fontFamily: 'Quark',
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: ScreenUtil().setWidth(130),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(33),
                                          fontFamily: 'Quark',
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: ScreenUtil().setWidth(20),
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
        fontSize: ScreenUtil().setSp(50),
        fontFamily: 'Quark',
        color: Color(0xFF3a3a3a),
      ),
    );
  }
}
