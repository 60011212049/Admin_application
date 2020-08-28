import 'dart:convert';
import 'dart:io';

import 'package:adminapp/model/comment_model.dart';
import 'package:adminapp/page_admin/add_comment.dart';
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
  List<CommentModel> commentForSearch = List<CommentModel>();
  TextEditingController editcontroller = TextEditingController();
  bool loading = false;
  bool isSearch = false;
  int tag = 1;
  List<String> options = [
    '5',
    '4',
    '3',
    '2',
    '1',
  ];

  List<bool> indexCh = [false, false, false, false, false];
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

  void filterSearchStar(int query) {
    List<CommentModel> dummySearchList = List<CommentModel>();
    dummySearchList.addAll(comment);
    if (query != 0) {
      List<CommentModel> dummyListData = List<CommentModel>();
      dummySearchList.forEach((item) {
        if (double.parse(item.rPoint).floor() == query) {
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
        title: isSearch == true
            ? Directionality(
                textDirection: Directionality.of(context),
                child: TextField(
                  key: Key('SearchBarTextField'),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'ค้นหารีวิว',
                      hintStyle: TextStyle(fontSize: 20),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none),
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  autofocus: true,
                  controller: editcontroller,
                ),
              )
            : Text(
                'ความคิดเห็น',
                style: TextStyle(
                  color: Color(0xFF3a3a3a),
                  fontSize: ScreenUtil().setSp(60),
                ),
              ),
        actions: [
          isSearch == true
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 27,
                  ),
                  onPressed: () {
                    editcontroller.text = '';
                    filterSearchResults('');
                    isSearch = false;
                    setState(() {});
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 27,
                  ),
                  onPressed: () {
                    isSearch = true;
                    setState(() {});
                  },
                ),
          isSearch == true
              ? Container()
              : IconButton(
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
                        Row(
                          children: [
                            (indexCh[4] != true)
                                ? borderSearchRating(5)
                                : boderSearchRating2(5),
                            (indexCh[3] != true)
                                ? borderSearchRating(4)
                                : boderSearchRating2(4),
                            (indexCh[2] != true)
                                ? borderSearchRating(3)
                                : boderSearchRating2(3),
                            (indexCh[1] != true)
                                ? borderSearchRating(2)
                                : boderSearchRating2(2),
                            (indexCh[0] != true)
                                ? borderSearchRating(1)
                                : boderSearchRating2(1),
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
                                Row(
                                  children: [
                                    Container(
                                      width: ScreenUtil().setSp(140),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        commentForSearch[index].rDetail != ''
                                            ? Container(
                                                width: 310,
                                                child: Text(
                                                  commentForSearch[index]
                                                      .rDetail,
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(49)),
                                                ),
                                              )
                                            : Container(),
                                        commentForSearch[index].cImage != ''
                                            ? ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 300,
                                                  maxHeight: 100,
                                                ),
                                                child: Image.network(
                                                  'http://' +
                                                      Service.ip +
                                                      '/controlModel/images/member/' +
                                                      commentForSearch[index]
                                                          .cImage,
                                                  fit: BoxFit.fitHeight,
                                                ))
                                            : Container(),
                                      ],
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

  Padding boderSearchRating2(int i) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
      child: Container(
        width: ScreenUtil().setWidth(120),
        height: ScreenUtil().setHeight(70),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[700],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
          color: Colors.yellow[700],
        ),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                i.toString(),
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              Icon(
                Icons.star,
                size: 12,
                color: Colors.grey[700],
              )
            ],
          ),
          onTap: () {
            if (indexCh[i - 1] == true) {
              filterSearchResults('');
              indexCh[i - 1] = false;
            } else if (indexCh[i - 1] == false) {
              for (var i = 0; i < indexCh.length; i++) {
                indexCh[i] = false;
              }
              filterSearchStar(i);
              indexCh[i - 1] = true;
            }

            print(indexCh[i - 1]);
            setState(() {});
          },
        ),
      ),
    );
  }

  Padding borderSearchRating(int i) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
      child: Container(
        width: ScreenUtil().setWidth(120),
        height: ScreenUtil().setHeight(70),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
          // color: Colors.white,
        ),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                i.toString(),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Icon(
                Icons.star,
                size: 12,
                color: Colors.grey,
              )
            ],
          ),
          onTap: () {
            if (indexCh[i - 1] == true) {
              filterSearchResults('');
              indexCh[i - 1] = false;
            } else if (indexCh[i - 1] == false) {
              for (var i = 0; i < indexCh.length; i++) {
                indexCh[i] = false;
              }
              indexCh[i - 1] = true;
              filterSearchStar(i);
            }
            print(indexCh[i - 1]);
            setState(() {});
          },
        ),
      ),
    );
  }
}
