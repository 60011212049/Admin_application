import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/busschedule_model.dart';
import 'package:adminapp/page_admin/add_bus_schedule.dart';
import 'package:adminapp/page_admin/edit_bus_schedule.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class ManageBusSchedule extends StatefulWidget {
  @override
  _ManageBusScheduleState createState() => _ManageBusScheduleState();
}

class _ManageBusScheduleState extends State<ManageBusSchedule> {
  List<BusscheduleModel> busSchedule = List<BusscheduleModel>();
  var status = {};

  @override
  void initState() {
    super.initState();
    getDataBusSchedule();
  }

  Future<Null> getDataBusSchedule() async {
    status['status'] = 'show';
    status['id'] = '';
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

  Future deleteDriver(String id) async {
    status['status'] = 'delete';
    status['id'] = id;
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busschedule_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("ลบข้อมูลไม่สำเร็จ", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        Toast.show("ลบข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        getDataBusSchedule();
        setState(() {});
      }
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการตารางการเดินรถ',
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBusSchedule(),
                  )).then((value) => getDataBusSchedule());
            },
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              child: Center(
                child: DataTable(
                  columnSpacing: ScreenUtil().setSp(80),
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
                    DataColumn(
                      label: textColumn(''),
                    ),
                  ],
                  rows: busSchedule
                      .map(
                        (data) => DataRow(
                          cells: [
                            DataCell(textRow(data.tCid)),
                            DataCell(textRow(data.tcTime)),
                            DataCell(textRow(data.cid)),
                            DataCell(
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: ScreenUtil().setSp(60),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditBusSchedule(data),
                                              ))
                                          .then(
                                              (value) => getDataBusSchedule());
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: ScreenUtil().setSp(60),
                                    ),
                                    onPressed: () {
                                      deleteDriver(data.tCid);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
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
