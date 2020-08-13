import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/comment_model.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  double rat = 0;
  List<CommentModel> comment = List<CommentModel>();
  bool loading = false;
  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void calRating() {
    rat = 0;
    double x = 0;
    for (var i = 0; i < comment.length; i++) {
      rat = rat + double.parse(comment[i].rPoint.toString());
      x = x + 1;
    }
    rat = double.parse((rat / x).toStringAsFixed(1));
  }

  Future<Null> refreshList() async {
    var status = {};
    status['status'] = 'show';
    status['id'] = '';
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/comment_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    this.comment = jsonData.map((i) => CommentModel.fromJson(i)).toList();
    loading = true;
    setState(() {
      calRating();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ความคิดเห็น',
          textScaleFactor: 1.2,
          style: TextStyle(
            color: Color(0xFF3a3a3a),
          ),
        ),
      ),
      body: RefreshIndicator(
        child: loading == true
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                          child: Text(
                            'คะแนนการรีวิวการใช้งาน',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              rat.toString(),
                              style: TextStyle(fontSize: 40),
                            ),
                            RatingBarIndicator(
                              rating: rat,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 40.0,
                              unratedColor: Colors.grey[300],
                            ),
                          ],
                        ),
                        Divider(
                          height: 5,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: comment.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            child: Container(
                                child: Wrap(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 2, 0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.yellow[700],
                                    radius: ScreenUtil().setSp(55),
                                    child: comment[index].rName == null
                                        ? Text(
                                            'user',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(50)),
                                          )
                                        : Text(
                                            comment[index]
                                                .rName
                                                .substring(0, 1),
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(50)),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        comment[index].rName,
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(51)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 5),
                                        child: RatingBarIndicator(
                                          rating: double.parse(
                                              comment[index].rPoint.toString()),
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 18.0,
                                          unratedColor: Colors.grey[300],
                                        ),
                                      ),
                                      Container(
                                        width: 310,
                                        child: Text(
                                          comment[index].rDetail,
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(49)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                          );
                        }),
                  )
                ],
              )
            : Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'กำลังโหลดข้อมูล..',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
        onRefresh: refreshList,
      ),
    );
  }
}
