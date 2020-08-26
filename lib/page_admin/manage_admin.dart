import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/admin_model.dart';
import 'package:adminapp/page_admin/add_admin.dart';
import 'package:adminapp/page_admin/edit_admin.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class ManageAdmin extends StatefulWidget {
  @override
  _ManageAdminState createState() => _ManageAdminState();
}

class _ManageAdminState extends State<ManageAdmin> {
  List<AdminModel> admin = List<AdminModel>();
  List<AdminModel> adminForSearch = List<AdminModel>();
  bool loading = false;
  TextEditingController editcontroller = TextEditingController();
  String idAdmin;
  @override
  void initState() {
    super.initState();
    getDataAdmin();
    getToken();
  }

  Future getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    idAdmin = token.getInt('tokenId').toString();
    print(token.getInt('tokenId'));
  }

  Future<Null> addTransciption(String id) async {
    var status = {};
    SharedPreferences pref = await SharedPreferences.getInstance();
    status['status'] = 'add';
    status['aid'] = pref.getInt('tokenId');
    status['type'] = 'ลบข้อมูลผู้ดูแลไอดี ' + id;
    status['time'] = DateTime.now().toString();
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/transcription_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
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
    loading = true;
    setState(() {});
  }

  Future deleteAdmin(String id) async {
    var status = {};
    status['status'] = 'delete';
    status['id'] = id;
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/admin_model.php',
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
        getDataAdmin();
      }
    } else {
      setState(() {});
    }
  }

  void filterSearchResults(String query) {
    List<AdminModel> dummySearchList = List<AdminModel>();
    dummySearchList.addAll(admin);
    if (query.isNotEmpty) {
      List<AdminModel> dummyListData = List<AdminModel>();
      dummySearchList.forEach((item) {
        if ((item.username.toLowerCase()).contains(query) ||
            (item.email.toLowerCase()).contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        adminForSearch.clear();
        adminForSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        adminForSearch.clear();
        adminForSearch.addAll(admin);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการข้อมูลผู้ดูแล',
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
                    builder: (context) => AddAdmin(),
                  )).then((value) {
                getDataAdmin();
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(
              'รายชื่อผู้ดูแล',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 31.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editcontroller,
                decoration: InputDecoration(
                    labelText: "ค้นหา",
                    labelStyle: TextStyle(fontSize: ScreenUtil().setSp(50)),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: adminForSearch.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: Icon(
                            Icons1.person,
                            color: Colors.grey[800],
                          )),
                      title: Text(
                        adminForSearch[index].username,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 23.0,
                        ),
                      ),
                      subtitle: Text(
                        adminForSearch[index].tell,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 13.0,
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
                                        EditAdmin(adminForSearch[index]),
                                  )).then((value) => getDataAdmin());
                            },
                          ),
                          idAdmin != adminForSearch[index].aid
                              ? IconButton(
                                  icon: Icon(
                                    Icons1.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    deleteAdmin(adminForSearch[index].aid);
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons1.delete,
                                    color: Colors.white,
                                  ),
                                )
                        ],
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
