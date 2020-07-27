import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/busschedule_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการตารางการเดินรถ',
          textScaleFactor: 1.2,
          style: TextStyle(
            color: Color(0xFF3a3a3a),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Center(
              child: DataTable(
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
                    .map((data) => DataRow(
                          cells: [
                            DataCell(textRow(data.tCid)),
                            DataCell(textRow(data.tcTime)),
                            DataCell(textRow(data.cid)),
                            DataCell(Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                ),
                                Icon(
                                  Icons.delete,
                                  size: 20,
                                ),
                              ],
                            )),
                          ],
                        ))
                    .toList(),
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
        fontSize: 15,
        fontFamily: 'Quark',
      ),
    );
  }

  Text textColumn(String data) {
    return Text(
      data,
      style: TextStyle(
        fontSize: 19,
        fontFamily: 'Quark',
        color: Color(0xFF3a3a3a),
      ),
    );
  }
}
