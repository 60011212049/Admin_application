import 'dart:convert';
import 'dart:io';
import 'package:adminapp/service/service.dart';
import 'package:http/http.dart' as http;
import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/busdriver_model.dart';
import 'package:adminapp/page_admin/add_driver.dart';
import 'package:flutter/material.dart';

class ManageDriver extends StatefulWidget {
  static List<BusdriverModel> busdriverList = List<BusdriverModel>();
  @override
  _ManageDriverState createState() => _ManageDriverState();
}

class _ManageDriverState extends State<ManageDriver> {
  var status = {};
  List<BusdriverModel> busdriverList = ManageDriver.busdriverList;

  Future<Null> getDataDriver() async {
    status['status'] = 'show';
    status['id'] = '';
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busdriver_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    ManageDriver.busdriverList =
        jsonData.map((i) => BusdriverModel.fromJson(i)).toList();
    setState(() {
      this.busdriverList = ManageDriver.busdriverList;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการข้อมูลคนขับรถ',
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
            ListView.builder(
              itemCount: busdriverList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: (busdriverList[index].dImage == '')
                          ? Icon(
                              Icons1.person,
                              color: Colors.grey[800],
                            )
                          : Image.network('http://' +
                              Service.ip +
                              '/controlModel/images/member/' +
                              busdriverList[index].dImage),
                    ),
                    title: Text(
                      busdriverList[index].dName,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 23.0,
                      ),
                    ),
                    subtitle: Text(
                      busdriverList[index].dTell,
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
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons1.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
              shrinkWrap: true,
            )
          ],
        ),
      ),
    );
  }
}
