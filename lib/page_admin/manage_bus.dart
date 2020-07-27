import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/bus_model.dart';
import 'package:adminapp/model/busdriver_model.dart';
import 'package:adminapp/page_admin/add_bus.dart';
import 'package:adminapp/page_admin/edit_bus.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class ManageBus extends StatefulWidget {
  @override
  _ManageBusState createState() => _ManageBusState();
}

class _ManageBusState extends State<ManageBus> {
  List<BusModel> listBus = List<BusModel>();
  List<BusdriverModel> listDriver = List<BusdriverModel>();
  bool loadData = false;
  var status = {};
  String text = '2';

  @override
  void initState() {
    super.initState();
    getDataBus();
    getDataDriver();
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
    setState(() {
      loadData = true;
    });
    return null;
  }

  Future<Null> getDataDriver() async {
    status['status'] = 'show';
    status['id'] = '';
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busdriver_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    listDriver = jsonData.map((i) => BusdriverModel.fromJson(i)).toList();
    setState(() {});
    return null;
  }

  Future<Null> deleteBus(String id) async {
    status['status'] = 'delete';
    status['cid'] = id;
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/bus_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print(response.body + ' ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("ลบข้อมูลไม่สำเร็จ", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else if (response.body.toString() == 'Good') {
        Toast.show("ลบข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        setState(() {
          getDataBus();
          getDataDriver();
        });
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
          'จัดการข้อมูลรถ',
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
                    builder: (context) => AddBus(),
                  )).then((value) {
                getDataBus();
                getDataDriver();
              });
            },
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: listBus.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(
                  listBus[index].cid,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: ScreenUtil().setSp(55),
                  ),
                ),
                subtitle: listDriver.length == 0
                    ? Text(
                        '',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: ScreenUtil().setSp(35),
                        ),
                      )
                    : Text(
                        'ชื่อคนขับ : ' +
                            checkDriver(listDriver, listBus[index].did),
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: ScreenUtil().setSp(40),
                        ),
                      ),
                trailing: Wrap(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons1.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBus(listBus[index].cid),
                            )).then((value) {
                          getDataBus();
                          getDataDriver();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons1.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteBus(listBus[index].cid);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          shrinkWrap: true,
        ),
      ),
    );
  }

  String checkDriver(List<BusdriverModel> listDriver, String did) {
    for (int i = 0; i < listDriver.length; i++) {
      if (listDriver[i].did == did) {
        return listDriver[i].dName;
      } else {}
    }
    return '';
  }
}
