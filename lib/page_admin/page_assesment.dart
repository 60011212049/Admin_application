import 'dart:convert';
import 'dart:io';

import 'package:adminapp/custom_icons.dart';
import 'package:adminapp/model/assesment_model.dart';
import 'package:adminapp/model/evaluation_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class PageAssesment extends StatefulWidget {
  @override
  _PageAssesmentState createState() => _PageAssesmentState();
}

class _PageAssesmentState extends State<PageAssesment> {
  List<AssesmentModel> quest = List<AssesmentModel>();
  List<AssesmentModel> questForSearch = List<AssesmentModel>();
  TextEditingController editcontroller = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getDataQuest();
  }

  Future getDataQuest() async {
    print('quest');
    var status = {};
    questForSearch.clear();
    status['status'] = 'show';
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/assesment_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    quest = jsonData.map((i) => AssesmentModel.fromJson(i)).toList();
    questForSearch.addAll(quest);
    loading = true;
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<AssesmentModel> dummySearchList = List<AssesmentModel>();
    dummySearchList.addAll(quest);
    if (query.isNotEmpty) {
      List<AssesmentModel> dummyListData = List<AssesmentModel>();
      dummySearchList.forEach((item) {
        if ((item.aDetail.toLowerCase()).contains(query) ||
            (item.aPoint.toLowerCase()).contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        questForSearch.clear();
        questForSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        questForSearch.clear();
        questForSearch.addAll(quest);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แบบประเมิน',
          style: TextStyle(
            color: Color(0xFF3a3a3a),
            fontSize: ScreenUtil().setSp(60),
          ),
        ),
      ),
      body: loading != true
          ? Container()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Container(
                    height: 50,
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      controller: editcontroller,
                      decoration: InputDecoration(
                          labelText: "ค้นหา",
                          labelStyle:
                              TextStyle(fontSize: ScreenUtil().setSp(50)),
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                ),
                for (var quest in quest)
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Text(
                          double.parse(quest.aPoint).toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      title: Text(
                        quest.aDetail,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      trailing: Wrap(
                        children: <Widget>[
                          // CircleAvatar(
                          //   backgroundColor: Colors.white,
                          //   child: Text(
                          //     double.parse(quest.aPoint).toStringAsFixed(2),
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                          IconButton(
                            icon: Icon(
                              Icons1.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) =>
                              //           EditBusstop(busForSearch[index]),
                              //     )).then((value) => getBusstop());
                            },
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
    );
  }
}
