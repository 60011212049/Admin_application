import 'package:adminapp/model/admin_model.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {

  static List<AdminModel> adminModel = List<AdminModel>();

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ผู้ดูแลระบบ'),
      ),
    );
  }
}
