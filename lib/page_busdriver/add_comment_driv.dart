import 'dart:convert';
import 'dart:io';

import 'package:adminapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AddComDriver extends StatefulWidget {
  @override
  _AddComDriverState createState() => _AddComDriverState();
}

class _AddComDriverState extends State<AddComDriver> {
  double ratingTrue;
  var _namecontroller = TextEditingController();
  var _detailcontroller = TextEditingController();
  File image;
  var fileName;
  bool userB = false;

  Future<Map<String, dynamic>> _uploadImage() async {
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse('http://' + Service.ip + '/controlModel/upload.php'));
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.files.add(file);
    print(mimeTypeData[0]);
    print(mimeTypeData[1]);
    print(image.path);
    print(file.filename);
    fileName = file.filename;
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        Toast.show("ไม่สามารถอัพรูปภาพได้ กรุณาใช้รูปภาพอื่น", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return null;
      } else {
        var res = await sentDataComment();
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future sentDataComment() async {
    var status = {};
    status['status'] = 'add';
    if (_namecontroller.text == '') {
      status['name'] = 'No name';
    } else {
      status['name'] = _namecontroller.text;
    }
    status['detail'] = _detailcontroller.text;
    status['point'] = ratingTrue.toString();
    status['image'] = fileName;
    String jsonSt = json.encode(status);
    var response = await http.post(
        'http://' + Service.ip + '/controlModel/comment_model.php',
        body: jsonSt,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print(response.statusCode.toString() + ' ' + response.body.toString());
    if (response.statusCode == 200) {
      if (response.body.toString() == 'Bad') {
        setState(() {
          Toast.show("เพิ่มข้อมูลไม่สำเร็จ", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        Toast.show("เพิ่มข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มความคิดเห็น',
          style: TextStyle(
            color: Color(0xFF3a3a3a),
            fontSize: ScreenUtil().setSp(60),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                      child: Text(
                        'คะแนนการรีวิวการใช้งาน',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(65),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: RatingBar(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            unratedColor: Colors.grey[300],
                            onRatingUpdate: (rating) {
                              print(rating);
                              ratingTrue = rating;
                            },
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 5,
                      color: Colors.black,
                    ),
                    Container(
                      height: 5,
                    ),
                    Container(
                      height: ScreenUtil().setHeight(250),
                      child: TextField(
                        maxLength: 20,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(50),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            userB = false;
                          }
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          errorStyle: TextStyle(fontSize: 16),
                          errorText: userB == true ? 'กรุณากรอกชื่อ' : null,
                          labelText: 'ชื่อเล่น',
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'ชื่อเล่น',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        controller: _namecontroller,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: TextField(
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(50),
                          ),
                          decoration: InputDecoration(
                            labelText: 'ข้อความ',
                            labelStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(50),
                            ),
                            hintText: 'ข้อความ',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          maxLength: 500,
                          controller: _detailcontroller,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Center(
                          child: image == null
                              ? Container()
                              : Center(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: 300,
                                      maxHeight: 100,
                                    ),
                                    child: Image.file(
                                      image,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'เพิ่มรูปภาพจากกล้อง',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () async {
                            var image;
                            try {
                              image = await ImagePicker.pickImage(
                                  source: ImageSource.camera);
                              this.image = image;
                            } catch (e) {}

                            setState(() {});
                          },
                        ),
                        Text(
                          'หรืออัลบั้ม',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () async {
                            var image;
                            try {
                              image = await ImagePicker.pickImage(
                                  source: ImageSource.gallery);
                              this.image = image;
                            } catch (e) {}

                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Center(
                      child: ButtonTheme(
                        minWidth: ScreenUtil().setWidth(650),
                        height: ScreenUtil().setHeight(170),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23.0),
                            ),
                            color: Colors.blue[700],
                            child: Text(
                              "เพิ่มความคิดเห็น",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quark',
                              ),
                            ),
                            onPressed: () async {
                              if (_namecontroller.text.isEmpty) {
                                userB = true;
                              }
                              setState(() {});
                              if (userB == false) {
                                try {
                                  if (image == null) {
                                    sentDataComment();
                                  } else {
                                    final Map<String, dynamic> response =
                                        await _uploadImage();
                                  }
                                } catch (e) {}
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
