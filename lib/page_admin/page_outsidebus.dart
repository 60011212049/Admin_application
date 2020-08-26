import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/outsidebus_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class PageOutSideBus extends StatefulWidget {
  @override
  _PageOutSideBusState createState() => _PageOutSideBusState();
}

class _PageOutSideBusState extends State<PageOutSideBus> {
  List<OutSideBusModel> outSide = List<OutSideBusModel>();
  var status = {};
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getDataOutSideBus();
  }

  Future<Null> getDataOutSideBus() async {
    status['status'] = 'show';
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/outside_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    outSide = jsonData.map((i) => OutSideBusModel.fromJson(i)).toList();
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
                      columnSpacing: ScreenUtil().setSp(80),
                      sortColumnIndex: 1,
                      columns: [
                        DataColumn(
                          label: textColumn('รหัสคนขับ'),
                        ),
                        DataColumn(
                          label: textColumn('รถราง'),
                        ),
                        DataColumn(
                          label: textColumn('เวลา'),
                        ),
                      ],
                      rows: (loading == true)
                          ? outSide
                              .map(
                                (data) => DataRow(
                                  cells: [
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(50),
                                        child: Text(
                                          data.did,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(40),
                                            fontFamily: 'Quark',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(250),
                                        child: Text(
                                          data.cid,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(42),
                                            fontFamily: 'Quark',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(400),
                                        child: Text(
                                          data.outDate.toString(),
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
                                      width: ScreenUtil().setWidth(250),
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
                                      width: ScreenUtil().setWidth(400),
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
