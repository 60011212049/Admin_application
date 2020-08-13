import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/bus_model.dart';
import 'package:adminapp/model/busposition_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AddBus extends StatefulWidget {
  @override
  _AddBusState createState() => _AddBusState();
}

class _AddBusState extends State<AddBus> {
  List<BusModel> listBus = List<BusModel>();
  var status = {};
  TextEditingController namecontroller = TextEditingController();
  TextEditingController statuscontroller = TextEditingController();
  bool loadData = false;

  @override
  void initState() {
    super.initState();
    getDataBus();
  }

  Future<Null> addTransciption() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    status['status'] = 'add';
    status['aid'] = pref.getInt('tokenId');
    status['type'] = 'เพิ่มข้อมูลรถราง ' + namecontroller.text;
    status['time'] = DateTime.now().toString();
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/transcription_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  }

  Future<void> addBusPosition(String text) async {
    var status = {};
    status['status'] = 'add';
    status['cid'] = text;
    status['date'] = DateTime.now().toString();
    status['time'] = TimeOfDay.now().hour.toString() +
        ':' +
        TimeOfDay.now().minute.toString() +
        ':00';
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busposition_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  }

  Future<Null> getDataBus() async {
    status['status'] = 'show';
    status['id'] = '';
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/bus_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    listBus = jsonData.map((i) => BusModel.fromJson(i)).toList();
    int tx = int.parse((listBus[listBus.length - 1].cid).substring(6));
    if (tx >= 99 && tx <= 999) {
      tx = tx + 1;
      namecontroller.text =
          (listBus[listBus.length - 1].cid).substring(0, listBus.length - 2) +
              tx.toString();
    } else if (tx >= 9 && tx <= 99) {
      tx = tx + 1;

      print((listBus[listBus.length - 1].cid)
          .substring(0, listBus[listBus.length - 1].cid.length - 2));
      namecontroller.text = (listBus[listBus.length - 1].cid)
              .substring(0, listBus[listBus.length - 1].cid.length - 2) +
          tx.toString();
    } else if (tx < 9) {
      tx = tx + 1;
      if (tx == 9) {
        namecontroller.text =
            (listBus[listBus.length - 1].cid).substring(0, listBus.length) +
                tx.toString();
      } else {
        namecontroller.text =
            (listBus[listBus.length - 1].cid).substring(0, listBus.length - 1) +
                tx.toString();
      }
    }
    setState(() {
      loadData = true;
    });
    return null;
  }

  Future<Null> sentDataBus() async {
    status['status'] = 'add';
    status['cid'] = namecontroller.text;
    if (statuscontroller.text == 'พร้อมใช้งาน') {
      status['statusbus'] = '1';
    } else if (statuscontroller.text == 'ไม่พร้อมใช้งาน') {
      status['statusbus'] = '0';
    }
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/bus_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print(response.statusCode.toString() + ' ' + response.body.toString());
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        Toast.show("ไม่สามารถเพิ่มข้อมูลได้", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("เพิ่มข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        addTransciption();
        addBusPosition(namecontroller.text);
        Navigator.pop(context);
      }
    } else {
      Toast.show("ไม่สามารถเพิ่มข้อมูลได้", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มข้อมูลรถ',
          style: TextStyle(
            color: Color(0xFF3a3a3a),
            fontSize: ScreenUtil().setSp(60),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'ข้อมูลรถ',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: ScreenUtil().setSp(80),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: Container(
                    child: TextField(
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(55),
                      ),
                      decoration: InputDecoration(
                        labelText: 'ชื่่อรหัสรถราง',
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'ชื่อรถ',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(55),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        prefixIcon: Icon(Icons.assignment_turned_in),
                      ),
                      controller: namecontroller,
                      readOnly: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: Container(
                    child: TextField(
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(55),
                      ),
                      decoration: InputDecoration(
                        labelText: 'สถานะรถราง',
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(55),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        prefixIcon: Icon(Icons.assignment_turned_in),
                      ),
                      controller: statuscontroller,
                      readOnly: true,
                      onTap: _askUser,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(12),
                ),
                ButtonTheme(
                  minWidth: 250.0,
                  height: ScreenUtil().setHeight(160),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23.0),
                    ),
                    color: Colors.blue[700],
                    child: Text(
                      "ยืนยันการเพิ่มข้อมูล",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Quark',
                      ),
                    ),
                    onPressed: () {
                      sentDataBus();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _value = '';

  void _setValue(String value) {
    setState(() {
      if (value == 'on') {
        statuscontroller.text = 'พร้อมใช้งาน';
      } else if (value == 'off') {
        statuscontroller.text = 'ไม่พร้อมใช้งาน';
      }
    });
  }

  Future _askUser() async {
    switch (await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text(
            'เลือกสถานะรถราง',
            style: TextStyle(fontSize: ScreenUtil().setSp(70)),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: textSize('พร้อมใช้งาน'),
              onPressed: () {
                Navigator.pop(context, '1');
              },
            ),
            SimpleDialogOption(
              child: textSize('ไม่พร้อมใช้งาน'),
              onPressed: () {
                Navigator.pop(context, '2');
              },
            ),
          ],
        ))) {
      case '1':
        _setValue('on');
        break;
      case '2':
        _setValue('off');
        break;
    }
  }

  Text textSize(String tex) {
    return Text(
      tex,
      style: TextStyle(fontSize: ScreenUtil().setSp(50)),
    );
  }
}
