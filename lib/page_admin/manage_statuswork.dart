import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/busdriver_model.dart';
import 'package:adminapp/model/statuswork_model.dart';
import 'package:adminapp/page_admin/add_statuswork.dart';
import 'package:adminapp/page_admin/edit_statuswork.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ManageStatusWork extends StatefulWidget {
  @override
  _ManageStatusWorkState createState() => _ManageStatusWorkState();
}

class _ManageStatusWorkState extends State<ManageStatusWork> {
  List<StatusWorkModel> stWork = List<StatusWorkModel>();
  List<StatusWorkModel> stWorkForSearch = List<StatusWorkModel>();
  List<BusdriverModel> driver = List<BusdriverModel>();
  TextEditingController editcontroller = TextEditingController();
  int check = 0;
  var status = {};
  bool isSearch = false;
  bool loading = false;

  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
  @override
  void initState() {
    super.initState();
    getDataStatusWork();
    getDataBusDriver();
  }

  Future<Null> getDataStatusWork() async {
    stWorkForSearch.clear();
    var status = {};
    status['status'] = 'show';
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/statuswork_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    stWork = jsonData.map((i) => StatusWorkModel.fromJson(i)).toList();
    stWorkForSearch.addAll(stWork);
    check++;
    if (check == 2) {
      loading = true;
      check = 0;
      setState(() {});
    }
    setState(() {});
  }

  Future<Null> addTransciption(String did) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var status = {};
    status['status'] = 'add';
    status['aid'] = pref.getInt('tokenId');
    status['type'] = 'ลบสถานะเข้าออกงานคนขับ ' +
        driver.firstWhere((element) => element.did == did).dName;
    status['time'] = DateTime.now().toString();
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/transcription_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  }

  Future<Null> deleteStatusWork(String id, String did) async {
    var status = {};
    status['status'] = 'delete';
    status['id'] = id;
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/statuswork_model.php',
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
        addTransciption(did);
        getDataStatusWork();
        setState(() {});
      }
    } else {
      setState(() {});
    }
  }

  Future<Null> getDataBusDriver() async {
    status['status'] = 'show';
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
      check = 0;
      setState(() {});
    }
  }

  void filterSearchResults(String query) {
    List<StatusWorkModel> dummySearchList = List<StatusWorkModel>();
    dummySearchList.addAll(stWork);
    if (query.isNotEmpty) {
      List<StatusWorkModel> dummyListData = List<StatusWorkModel>();
      dummySearchList.forEach((item) {
        if ((item.inDate.hour.toString().toLowerCase()).contains(query) ||
            (item.inDate.minute.toString().toLowerCase()).contains(query) ||
            (item.outDate.hour.toString().toLowerCase()).contains(query) ||
            (item.outDate.minute.toString().toLowerCase()).contains(query) ||
            (driver.firstWhere((element) => element.did == item.did).dName)
                .contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        stWorkForSearch.clear();
        stWorkForSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        stWorkForSearch.clear();
        stWorkForSearch.addAll(stWork);
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
                        hintText: 'ค้นหา',
                        hintStyle: TextStyle(fontSize: 20),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none),
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    autofocus: true,
                    controller: editcontroller,
                  ),
                )
              : Text(
                  'ตรวจสอบสถานะการเข้างาน',
                  style: TextStyle(
                    color: Color(0xFF3a3a3a),
                    fontSize: ScreenUtil().setSp(60),
                  ),
                ),
          actions: [
            isSearch == true
                ? IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 27,
                    ),
                    onPressed: () {
                      // editcontroller.text = '';
                      // filterSearchResults('');
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
                            builder: (context) => AddStatusWork(),
                          )).then((value) => null);
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
                      columnSpacing: ScreenUtil().setSp(10),
                      sortColumnIndex: 1,
                      columns: [
                        DataColumn(
                          label: textColumn('ชื่อคนขับ'),
                        ),
                        DataColumn(
                          label: textColumn('เข้าเวลา'),
                        ),
                        DataColumn(
                          label: textColumn('ออกเวลา'),
                        ),
                        DataColumn(
                          label: textColumn(''),
                        ),
                        DataColumn(
                          label: textColumn(''),
                        ),
                      ],
                      rows: (loading == true)
                          ? stWorkForSearch
                              .map(
                                (data) => DataRow(
                                  cells: [
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(200),
                                        child: Text(
                                          driver
                                              .firstWhere((element) =>
                                                  element.did == data.did)
                                              .dName,
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
                                          DateFormat('kk:mm dd-MM-yyyy')
                                              .format(data.inDate),
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
                                          DateFormat('kk:mm dd-MM-yyyy')
                                              .format(data.outDate),
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(33),
                                            fontFamily: 'Quark',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
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
                                                    EditStatusWork(data),
                                              )).then((value) {
                                            getDataStatusWork();
                                          });
                                        },
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: ScreenUtil().setSp(60),
                                        ),
                                        onPressed: () {
                                          deleteStatusWork(
                                              data.idStwork, data.did);
                                        },
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
