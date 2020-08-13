import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/comment_model.dart';
import 'package:adminapp/page_admin/add_comment.dart';
import 'package:adminapp/page_admin/edit_comment.dart';
import 'package:adminapp/page_busdriver/comment_page.dart';
import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class CommentPageAdmin extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPageAdmin> {
  double rat = 0;
  List<CommentModel> comment = List<CommentModel>();
  List<CommentModel> commentForSearch = List<CommentModel>();
  TextEditingController editcontroller = TextEditingController();
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

  Future addTransciption(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var status = {};
    status['status'] = 'add';
    status['aid'] = pref.getInt('tokenId');
    status['type'] = 'ลบข้อมูลรีวิวไอดี ' + id;
    status['time'] = DateTime.now().toString();
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/transcription_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  }

  Future refreshList() async {
    var status = {};
    status['status'] = 'show';
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/comment_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    List jsonData = json.decode(response.body);
    this.comment = jsonData.map((i) => CommentModel.fromJson(i)).toList();
    commentForSearch.addAll(comment);
    filterSearchResults(editcontroller.text);
    loading = true;
    setState(() {
      calRating();
    });
  }

  Future deleteComment(String rid) async {
    var status = {};
    status['status'] = 'delete';
    status['id'] = rid;
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/comment_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("ลบข้อมูลไม่สำเร็จ", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        Toast.show("ลบข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        addTransciption(rid);
        refreshList();
      }
    } else {}
  }

  void filterSearchResults(String query) {
    List<CommentModel> dummySearchList = List<CommentModel>();
    dummySearchList.addAll(comment);
    if (query.isNotEmpty) {
      List<CommentModel> dummyListData = List<CommentModel>();
      dummySearchList.forEach((item) {
        if ((item.rDetail.toLowerCase()).contains(query) ||
            (item.rName.toLowerCase()).contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        commentForSearch.clear();
        commentForSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        commentForSearch.clear();
        commentForSearch.addAll(comment);
      });
    }
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddComment(),
                  )).then((value) => refreshList());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        child: loading == true
            ? Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                        itemCount: commentForSearch.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            child: Container(
                                child: Wrap(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 2, 0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.yellow[700],
                                    radius: ScreenUtil().setSp(55),
                                    child: commentForSearch[index].rName == null
                                        ? Text(
                                            'user',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(50)),
                                          )
                                        : Text(
                                            commentForSearch[index]
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
                                        commentForSearch[index].rName,
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(51)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 5),
                                        child: RatingBarIndicator(
                                          rating: double.parse(
                                              commentForSearch[index]
                                                  .rPoint
                                                  .toString()),
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 18.0,
                                          unratedColor: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditComment(
                                            commentForSearch[index]),
                                      ),
                                    ).then((value) => refreshList());
                                  },
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      deleteComment(
                                          commentForSearch[index].rid);
                                    }),
                                Row(
                                  children: [
                                    Container(
                                      width: ScreenUtil().setSp(140),
                                    ),
                                    Container(
                                      width: 310,
                                      child: Text(
                                        commentForSearch[index].rDetail,
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(49)),
                                      ),
                                    ),
                                  ],
                                )
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
