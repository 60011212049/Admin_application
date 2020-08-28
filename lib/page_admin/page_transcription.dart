import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/admin_model.dart';
import 'package:adminapp/model/busschedule_model.dart';
import 'package:adminapp/model/transcription_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Transcription extends StatefulWidget {
  @override
  _TranscriptionState createState() => _TranscriptionState();
}

class _TranscriptionState extends State<Transcription> {
  List<TranscriptionModel> tran = List<TranscriptionModel>();
  List<TranscriptionModel> tranForSearch = List<TranscriptionModel>();
  List<AdminModel> admin = List<AdminModel>();
  List<AdminModel> adminForSearch = List<AdminModel>();
  bool isSearch = false;
  TextEditingController editcontroller = TextEditingController();
  var status = {};
  int check = 0;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getDataTransciption();
    getDataAdmin();
  }

  Future<Null> getDataTransciption() async {
    tranForSearch.clear();
    status['status'] = 'show';
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/transcription_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    tran = jsonData.map((i) => TranscriptionModel.fromJson(i)).toList();
    tranForSearch.addAll(tran);
    check++;
    if (check == 2) {
      loading = true;
      setState(() {});
    }
  }

  Future<Null> getDataAdmin() async {
    adminForSearch.clear();
    var status = {};
    status['status'] = 'show';
    String jsonSt = json.encode(status);
    print(jsonSt);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/admin_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    admin = jsonData.map((e) => AdminModel.fromJson(e)).toList();
    adminForSearch.addAll(admin);
    check++;
    if (check == 2) {
      loading = true;
      setState(() {});
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<TranscriptionModel> dummySearchListTran = List<TranscriptionModel>();
    dummySearchListTran.addAll(tran);
    if (query.isNotEmpty) {
      List<TranscriptionModel> dummyListDataTran = List<TranscriptionModel>();
      dummySearchListTran.forEach((item) {
        if ((item.tType.toLowerCase()).contains(query) ||
            (item.tDatetime.toLowerCase()).contains(query) ||
            (admin
                    .firstWhere((element) => element.aid == item.tAid)
                    .username
                    .toLowerCase())
                .contains(query)) {
          dummyListDataTran.add(item);
        }
      });

      setState(() {
        tranForSearch.clear();
        tranForSearch.addAll(dummyListDataTran);
      });
      return;
    } else {
      setState(() {
        tranForSearch.clear();
        tranForSearch.addAll(tran);
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
                        hintText: 'ค้นหาประวัติการใช้งาน',
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
                  'ประวัติการใช้งาน',
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
                      editcontroller.text = '';
                      filterSearchResults('');
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
          ],
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
                          ? tranForSearch
                              .map(
                                (data) => DataRow(
                                  cells: [
                                    DataCell(
                                      Container(
                                        width: ScreenUtil().setWidth(130),
                                        child: Text(
                                          admin
                                              .firstWhere((element) =>
                                                  element.aid == data.tAid)
                                              .username,
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
                                          DateFormat('kk:mm dd-MM-yyyy').format(
                                              DateTime.parse(data.tDatetime)),
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
