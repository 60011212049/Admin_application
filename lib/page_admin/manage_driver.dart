import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/busdriver_model.dart';
import 'package:flutter/material.dart';

class ManageDriver extends StatefulWidget {
  static List<BusdriverModel> busdriverList = List<BusdriverModel>();
  @override
  _ManageDriverState createState() => _ManageDriverState();
}

class _ManageDriverState extends State<ManageDriver> {
  List<BusdriverModel> busdriverList = ManageDriver.busdriverList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จัดการข้อมูลคนขับรถ'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {},
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
                      child: Icon(
                        Icons1.person,
                        color: Colors.grey[800],
                      ),
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
