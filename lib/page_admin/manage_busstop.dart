import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/busstop_model.dart';
import 'package:adminapp/page_admin/edit_busstop.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageBusstop extends StatefulWidget {
  static List<BusstopModel> busstop = List<BusstopModel>();

  @override
  _ManageBusstopState createState() => _ManageBusstopState();
}

class _ManageBusstopState extends State<ManageBusstop> {
  var status = {};
  List<BusstopModel> busstop = ManageBusstop.busstop;
  Future<Null> getBusstop() async {
    status['status'] = 'show';
    status['id'] = '';
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/busstop_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    busstop = jsonData.map((i) => BusstopModel.fromJson(i)).toList();
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการจัดรับส่งผู้โดยสาร',
          textScaleFactor: 1.2,
          style: TextStyle(
            color: Color(0xFF3a3a3a),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: busstop.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(
                  busstop[index].sName,
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
                              builder: (context) => EditBusstop(busstop[index]),
                            )).then((value) => getBusstop());
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons1.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
