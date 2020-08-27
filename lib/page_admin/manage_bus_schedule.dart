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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ManageBusSchedule extends StatefulWidget {
  @override
  _ManageBusScheduleState createState() => _ManageBusScheduleState();
}

class _ManageBusScheduleState extends State<ManageBusSchedule> {
  List<BusscheduleModel> busSchedule = List<BusscheduleModel>();
  List<BusscheduleModel> busScheduleForSearch = List<BusscheduleModel>();
  TextEditingController editcontroller = TextEditingController();
  var status = {};
  bool loading = false;
  bool isSearch = false;
  int i = 0;
  @override
  void initState() {
    super.initState();
    this.i = 0;
    getDataBusSchedule();
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

  Future<Null> addTransciption(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    status['status'] = 'add';
    status['aid'] = pref.getInt('tokenId');
    status['type'] = 'ลบข้อมูลตารางเดินรถไอดี ' + id;
    status['time'] = DateTime.now().toString();
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/transcription_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  }

  Future<Null> getDataBusSchedule() async {
    busScheduleForSearch.clear();
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
    busScheduleForSearch.addAll(busSchedule);
    loading = true;
    this.i = 0;
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
        addTransciption(id);
        this.i = 0;
      }
    } else {
      this.i = 0;
      setState(() {});
    }
  }

  void filterSearchResults(String query) {
    this.i = 0;
    List<BusscheduleModel> dummySearchList = List<BusscheduleModel>();
    dummySearchList.addAll(busSchedule);
    if (query.isNotEmpty) {
      List<BusscheduleModel> dummyListData = List<BusscheduleModel>();
      dummySearchList.forEach((item) {
        if ((item.cid.toLowerCase()).contains(query) ||
            (item.tcTime.toLowerCase()).contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        this.i = 0;
        busScheduleForSearch.clear();
        busScheduleForSearch.addAll(dummyListData);
      });
      return;
    } else {
      this.i = 0;
      setState(() {
        busScheduleForSearch.clear();
        busScheduleForSearch.addAll(busSchedule);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearch == true
            ? Directionality(
                textDirection: Directionality.of(context),
                child: TextField(
                  key: Key('SearchBarTextField'),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'ค้นหาตารางเดินรถ',
                      hintStyle: TextStyle(fontSize: 20),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none),
                  onChanged: (value) {
                    this.i = 0;
                    filterSearchResults(value);
                  },
                  autofocus: true,
                  controller: editcontroller,
                ),
              )
            : Text(
                'จัดการตารางการเดินรถ',
                style: TextStyle(
                  color: Color(0xFF3a3a3a),
                  fontSize: ScreenUtil().setSp(60),
                ),
              ),
        actions: <Widget>[
          isSearch == true
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 27,
                  ),
                  onPressed: () {
                    editcontroller.text = '';
                    filterSearchResults('');
                    this.i = 0;
                    isSearch = false;
                    setState(() {});
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 27,
                  ),
                  onPressed: () {
                    isSearch = true;
                    this.i = 0;
                    setState(() {});
                  },
                ),
          isSearch == true
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddBusSchedule(),
                        )).then((value) {
                      this.i = 0;
                      getDataBusSchedule();
                    });
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
                  rows: (loading == true)
                      ? busScheduleForSearch
                          .map(
                            (data) => DataRow(
                              cells: [
                                DataCell(
                                  Container(
                                    width: ScreenUtil().setWidth(50),
                                    child: Text(
                                      countRound().toString(),
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(40),
                                        fontFamily: 'Quark',
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    width: ScreenUtil().setWidth(200),
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
                                    width: ScreenUtil().setWidth(200),
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
                                              )).then((value) {
                                            getDataBusSchedule();
                                            this.i = 0;
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: ScreenUtil().setSp(60),
                                        ),
                                        onPressed: () {
                                          this.i = 0;
                                          deleteDriver(data.tCid);
                                        },
                                      ),
                                    ],
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
                                  width: ScreenUtil().setWidth(200),
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
                                  width: ScreenUtil().setWidth(200),
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
                                  width: ScreenUtil().setWidth(200),
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
