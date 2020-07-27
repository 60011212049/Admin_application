import 'dart:convert';
import 'dart:io';
import 'package:adminapp/page_admin/edit_driver.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/busdriver_model.dart';
import 'package:adminapp/page_admin/add_driver.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ManageDriver extends StatefulWidget {
  static List<BusdriverModel> busdriverList = List<BusdriverModel>();
  @override
  _ManageDriverState createState() => _ManageDriverState();
}

class _ManageDriverState extends State<ManageDriver> {
  var status = {};
  List<BusdriverModel> busdriverList = List<BusdriverModel>();
  List<BusdriverModel> driverForSearch = List<BusdriverModel>();

  TextEditingController editcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataDriver();
  }

  Future<Null> getDataDriver() async {
    driverForSearch.clear();
    status['status'] = 'show';
    status['id'] = '';
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busdriver_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    busdriverList = jsonData.map((i) => BusdriverModel.fromJson(i)).toList();
    driverForSearch.addAll(busdriverList);
    filterSearchResults(editcontroller.text);
    setState(() {});
    return null;
  }

  Future<Null> deleteDriver(String id) async {
    status['status'] = 'delete';
    status['id'] = id;
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busdriver_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("ลบข้อมูลไม่สำเร็จ", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        getDataDriver();
        setState(() {});
      }
    } else {
      setState(() {});
    }
    return null;
  }

  void filterSearchResults(String query) {
    List<BusdriverModel> dummySearchList = List<BusdriverModel>();
    dummySearchList.addAll(busdriverList);
    if (query.isNotEmpty) {
      List<BusdriverModel> dummyListData = List<BusdriverModel>();
      dummySearchList.forEach((item) {
        if ((item.dName.toLowerCase()).contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        driverForSearch.clear();
        driverForSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        driverForSearch.clear();
        driverForSearch.addAll(busdriverList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการข้อมูลคนขับรถ',
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
                    builder: (context) => AddBusDriver(),
                  )).then((value) => getDataDriver());
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(
              'รายชื่อคนขับรถ',
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
                    labelText: "ค้นหาจากชื่อ",
                    labelStyle: TextStyle(fontSize: ScreenUtil().setSp(50)),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: driverForSearch.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        child: (driverForSearch[index].dImage == '')
                            ? Icon(
                                Icons1.person,
                                color: Colors.grey[800],
                              )
                            : Image.network('http://' +
                                Service.ip +
                                '/controlModel/images/member/' +
                                driverForSearch[index].dImage),
                      ),
                      title: Text(
                        driverForSearch[index].dName,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 23.0,
                        ),
                      ),
                      subtitle: Text(
                        driverForSearch[index].dTell,
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
                                    builder: (context) => EditBusDriver(
                                        driverForSearch[index].did),
                                  )).then((value) => getDataDriver());
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons1.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              deleteDriver(driverForSearch[index].did);
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
