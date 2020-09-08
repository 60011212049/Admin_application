import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/busdriver_model.dart';
import 'package:adminapp/model/outsidebus_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PageOutSideBus extends StatefulWidget {
  @override
  _PageOutSideBusState createState() => _PageOutSideBusState();
}

class _PageOutSideBusState extends State<PageOutSideBus> {
  List<OutSideBusModel> outSide = List<OutSideBusModel>();
  List<BusdriverModel> driver = List<BusdriverModel>();
  int check = 0;
  var status = {};
  bool loading = false;
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
  @override
  void initState() {
    super.initState();
    getDataOutSideBus();
    getDataBusDriver();
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
    check++;
    if (check == 2) {
      loading = true;
      setState(() {});
    }
  }

  Future<Null> getDataBusDriver() async {
    status['status'] = 'showAll';
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busdriver_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    driver = jsonData.map((i) => BusdriverModel.fromJson(i)).toList();
    check++;
    if (check == 2) {
      loading = true;
      setState(() {});
    }
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
                          label: textColumn('ชื่อคนขับ'),
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
                                        width: ScreenUtil().setWidth(100),
                                        child: Text(
                                          driver
                                              .firstWhere((element) =>
                                                  element.did == data.did)
                                              .dName,
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
                                          DateFormat('kk:mm dd-MM-yyyy')
                                              .format(data.outDate),
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(35),
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
                                          fontSize: ScreenUtil().setSp(35),
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
                                          fontSize: ScreenUtil().setSp(35),
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
                                          fontSize: ScreenUtil().setSp(35),
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
        fontSize: ScreenUtil().setSp(55),
        fontFamily: 'Quark',
        color: Color(0xFF3a3a3a),
      ),
    );
  }
}
