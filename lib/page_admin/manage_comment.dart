import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/comment_model.dart';
import 'package:adminapp/page_busdriver/comment_page.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:http/http.dart' as http;

class CommentPageAdmin extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPageAdmin> {
  double rat = 0;
  List<CommentModel> comment = CommentPage.comment;
  @override
  void initState() {
    super.initState();
    calRating();
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
    print(response.statusCode.toString() + ' ' + response.body.toString());
    List jsonData = json.decode(response.body);
    this.comment = jsonData.map((i) => CommentModel.fromJson(i)).toList();
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
          style: TextStyle(
            color: Color(0xFF3a3a3a),
            fontSize: ScreenUtil().setSp(60),
          ),
        ),
      ),
      body: RefreshIndicator(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Container(
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    for (var i = comment.length - 1; i >= 0; i--)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3, 5, 3, 5),
                        child: Container(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 2, 0),
                              child: CircleAvatar(
                                backgroundColor: Colors.yellow[700],
                                radius: 22,
                                child: Text('user'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    comment[i].rName,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    child: RatingBarIndicator(
                                      rating: double.parse(
                                          comment[i].rPoint.toString()),
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
                                      comment[i].rDetail,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
        onRefresh: refreshList,
      ),
    );
  }
}
