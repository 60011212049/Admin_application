import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/busstop_model.dart';
import 'package:adminapp/page_admin/add_busstop.dart';
import 'package:adminapp/page_admin/edit_busstop.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ManageBusstop extends StatefulWidget {
  static List<BusstopModel> busstop = List<BusstopModel>();

  @override
  _ManageBusstopState createState() => _ManageBusstopState();
}

class _ManageBusstopState extends State<ManageBusstop> {
  TextEditingController editcontroller = TextEditingController();
  var status = {};
  List<BusstopModel> busstop = List<BusstopModel>();
  List<BusstopModel> busForSearch = List<BusstopModel>();

  @override
  void initState() {
    super.initState();
    getBusstop();
  }

  Future<Null> addTransciption(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    status['status'] = 'add';
    status['aid'] = pref.getInt('tokenId');
    status['type'] = 'ลบข้อมูลจุดรับส่งไอดี ' + id;
    status['time'] = DateTime.now().toString();
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/transcription_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  }

  Future<Null> getBusstop() async {
    busForSearch.clear();
    status['status'] = 'show';
    status['id'] = '';
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busstop_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    busstop = jsonData.map((i) => BusstopModel.fromJson(i)).toList();
    busForSearch.addAll(busstop);
    filterSearchResults(editcontroller.text);
    setState(() {});
    return null;
  }

  Future deleteDriver(String id) async {
    status['status'] = 'delete';
    status['id'] = id;
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busstop_model.php',
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
        addTransciption(id);
        getBusstop();
        setState(() {});
      }
    } else {
      setState(() {});
    }
  }

  void filterSearchResults(String query) {
    List<BusstopModel> dummySearchList = List<BusstopModel>();
    dummySearchList.addAll(busstop);
    if (query.isNotEmpty) {
      List<BusstopModel> dummyListData = List<BusstopModel>();
      dummySearchList.forEach((item) {
        if ((item.sName.toLowerCase()).contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        busForSearch.clear();
        busForSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        busForSearch.clear();
        busForSearch.addAll(busstop);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการจัดรับส่งผู้โดยสาร',
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
                    builder: (context) => AddBusstop(),
                  )).then((value) => getBusstop());
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editcontroller,
                decoration: InputDecoration(
                    labelText: "ค้นหาจากชื่อ",
                    labelStyle: TextStyle(fontSize: ScreenUtil().setSp(50)),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: busForSearch.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      busForSearch[index].sName,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18.0,
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
                                  builder: (context) =>
                                      EditBusstop(busForSearch[index]),
                                )).then((value) => getBusstop());
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons1.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteDriver(busForSearch[index].sid);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
