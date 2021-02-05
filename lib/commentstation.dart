import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:intl/intl.dart';

class LoadCommentScreen extends StatefulWidget {
  final User user;

  const LoadCommentScreen({Key key, this.user}) : super(key: key);

  @override
  _LoadCommentScreenState createState() => _LoadCommentScreenState();
}

class _LoadCommentScreenState extends State<LoadCommentScreen> {
  List reviewlist;
  List cookiesList;

  String titlecenter = "No data found";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadReview();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Text(
            'Comment station',
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _loadReview();
              },
            ),
          ]),
      body: Column(
        children: [
          reviewlist == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.21,
                  children: List.generate(reviewlist.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: new BorderSide(
                                  color: Colors.grey[350], width: 1.0),
                            ),
                            child: SingleChildScrollView(
                                child: Row(children: [
                              Container(
                                  height: 100,
                                  width: 100,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://doubleksc.com/my_daily_cookies/images/cookiesimages/${reviewlist[index]['image']}.jpg",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 80.0,
                                      height: 80.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                        new CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        new Icon(
                                      Icons.broken_image,
                                      size: screenWidth / 2,
                                    ),
                                  )),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reviewlist[index]['cookiesname'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown),
                                  ),
                                  Text(
                                    "Comment by: " + reviewlist[index]['name'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown),
                                  ),
                                  Text(
                                    "Comment : " + reviewlist[index]['review'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown),
                                  ),
                                ],
                              )
                            ]))));
                  }),
                ))
        ],
      ),
    ));
  }

  void _loadReview() {
    http.post("http://doubleksc.com/my_daily_cookies/php/load_comment.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "no data") {
        reviewlist = null;
        setState(() {
          titlecenter = "No data";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          reviewlist = jsondata["review"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
