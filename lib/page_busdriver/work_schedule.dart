import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/busschedule_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class WorkSchedule extends StatefulWidget {
  String id;
  WorkSchedule(String did) {
    this.id = did;
  }

  @override
  _WorkScheduleState createState() => _WorkScheduleState(id);
}

class _WorkScheduleState extends State<WorkSchedule> {
  List<BusscheduleModel> busSchedule = List<BusscheduleModel>();
  var status = {};

  _WorkScheduleState(did) {
    getDataBusSchedule(did);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Null> getDataBusSchedule(String did) async {
    status['status'] = 'showWhereId';
    status['id'] = did;
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busschedule_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    busSchedule = jsonData.map((i) => BusscheduleModel.fromJson(i)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ตารางการเดินรถ',
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
                  columnSpacing: ScreenUtil().setSp(120),
                  showCheckboxColumn: true,
                  sortAscending: true,
                  sortColumnIndex: 1,
                  columns: [
                    DataColumn(
                      label: textColumn('รอบที่'),
                    ),
                    DataColumn(
                      label: textColumn('เวลา'),
                    ),
                    DataColumn(
                      label: textColumn('รถราง'),
                    ),
                  ],
                  rows: (busSchedule.length != 0)
                      ? busSchedule
                          .map(
                            (data) => DataRow(
                              cells: [
                                DataCell(
                                  Container(
                                    width: ScreenUtil().setWidth(50),
                                    child: Text(
                                      data.tCid,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(40),
                                        fontFamily: 'Quark',
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    width: ScreenUtil().setWidth(300),
                                    child: Text(
                                      data.tcTime,
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
                                      data.cid,
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
                                  width: ScreenUtil().setWidth(300),
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
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text textRow(data) {
    return Text(
      data,
      style: TextStyle(
        fontSize: ScreenUtil().setSp(40),
        fontFamily: 'Quark',
      ),
    );
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
