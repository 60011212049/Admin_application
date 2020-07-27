import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/member_model.dart';
import 'package:adminapp/page_admin/add_user.dart';
import 'package:adminapp/page_admin/edit_user.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class ManageUser extends StatefulWidget {
  @override
  _ManageUserState createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  var status = {};
  List<MemberModel> memberList = List<MemberModel>();
  List<MemberModel> memForSearch = List<MemberModel>();
  TextEditingController editcontroller = TextEditingController();
  bool loadData = false;

  @override
  void initState() {
    super.initState();
    getDataMember();
  }

  Future<Null> getDataMember() async {
    memForSearch.clear();
    status['status'] = 'show';
    status['id'] = '';
    String jsonSt = json.encode(status);

    var response = await http.post(
        'http://' + Service.ip + '/controlModel/member_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    memberList = jsonData.map((i) => MemberModel.fromJson(i)).toList();
    memForSearch.addAll(memberList);
    filterSearchResults(editcontroller.text);
    setState(() {
      loadData = true;
    });
    return null;
  }

  Future<Null> deleteDriver(String id) async {
    status['status'] = 'delete';
    status['id'] = id;
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/member_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("ลบข้อมูลไม่สำเร็จ", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else if (response.body.toString() == 'Good') {
        Toast.show("ลบข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        getDataMember();
        setState(() {});
      }
    } else {
      setState(() {});
    }
  }

  void filterSearchResults(String query) {
    List<MemberModel> dummySearchList = List<MemberModel>();
    dummySearchList.addAll(memberList);
    if (query.isNotEmpty) {
      List<MemberModel> dummyListData = List<MemberModel>();
      dummySearchList.forEach((item) {
        if ((item.mName.toLowerCase()).contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        memForSearch.clear();
        memForSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        memForSearch.clear();
        memForSearch.addAll(memberList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการข้อมูลผู้ใช้งาน',
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
                    builder: (context) => AddUser(),
                  )).then((value) => getDataMember());
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'รายชื่อผู้ใช้งาน',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 31.0,
                ),
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
                    labelText: "ค้นหาจากชื่อ",
                    labelStyle: TextStyle(fontSize: ScreenUtil().setSp(50)),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            loadData == false
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: memForSearch.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[100],
                              child: (memForSearch[index].mImage == '')
                                  ? Icon(
                                      Icons1.person,
                                      color: Colors.grey[800],
                                    )
                                  : Image.network('http://' +
                                      Service.ip +
                                      '/controlModel/images/member/' +
                                      memForSearch[index].mImage),
                            ),
                            title: Text(
                              memForSearch[index].mName,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 20.0,
                              ),
                            ),
                            subtitle: Text(
                              memForSearch[index].mEmail,
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
                                              EditUser(memForSearch[index].mid),
                                        )).then((value) => getDataMember());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons1.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    deleteDriver(memForSearch[index].mid);
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
                  )
          ],
        ),
      ),
    );
  }
}
