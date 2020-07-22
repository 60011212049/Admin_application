import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/member_model.dart';
import 'package:adminapp/page_admin/add_user.dart';
import 'package:adminapp/page_admin/edit_user.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class ManageUser extends StatefulWidget {
  @override
  _ManageUserState createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  var status = {};
  List<MemberModel> memberList = List<MemberModel>();
  bool loadData = false;

  @override
  void initState() {
    super.initState();
    getDataMember();
  }

  Future<Null> getDataMember() async {
    status['status'] = 'show';
    status['id'] = '';
    String jsonSt = json.encode(status);

    var response = await http.post(
        'http://' + Service.ip + '/controlModel/member_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    memberList = jsonData.map((i) => MemberModel.fromJson(i)).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการข้อมูลผู้ใช้งาน',
          textScaleFactor: 1.2,
          style: TextStyle(
            color: Color(0xFF3a3a3a),
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
            loadData == false
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: ListView.builder(
                      itemCount: memberList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[100],
                              child: (memberList[index].mImage == '')
                                  ? Icon(
                                      Icons1.person,
                                      color: Colors.grey[800],
                                    )
                                  : Image.network('http://' +
                                      Service.ip +
                                      '/controlModel/images/member/' +
                                      memberList[index].mImage),
                            ),
                            title: Text(
                              memberList[index].mName,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 20.0,
                              ),
                            ),
                            subtitle: Text(
                              memberList[index].mEmail,
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
                                              EditUser(memberList[index].mid),
                                        )).then((value) => getDataMember());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons1.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    deleteDriver(memberList[index].mid);
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
