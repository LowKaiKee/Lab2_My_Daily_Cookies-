import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:my_daily_cookies/recipe.dart';
import 'package:my_daily_cookies/user.dart';
import 'package:toast/toast.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipess;
  final User userss;

  RecipeDetail(this.recipess, this.userss);
  @override
  _RecipeDetailState createState() => _RecipeDetailState(recipess, userss);
}

class _RecipeDetailState extends State<RecipeDetail> {
  Recipe recipes;
  User users;
  _RecipeDetailState(Recipe recipes, User userss);
  List recipeList;
  List commentList;
  double screenHeight, screenWidth;
  String _comment = "";
  String titlecenter = "Loading post...";
  final TextEditingController _commentcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    recipes = widget.recipess;
    users = widget.userss;
    _loadDetails();
    _loadComment();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            backgroundColor: Colors.brown,
            title: Text(
              widget.recipess.name,
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  _loadComment();
                },
              ),
            ]),
        body: Column(children: [
          Container(
              padding: EdgeInsets.all(0),
              child: (Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Container(
                              child: Column(children: [
                            Container(
                                height: 200,
                                width: 400,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://doubleksc.com/my_daily_cookies/images/cookiesimages/${widget.recipess.image}.jpg",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      new Icon(
                                    Icons.broken_image,
                                    size: screenWidth / 2,
                                  ),
                                )),
                            SizedBox(height: 5),
                            LikeButton(),
                            Row(children: [
                              Text(recipes.name,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold)),
                            ]),
                            Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: Text(
                                      recipes.recipe,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.brown),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ])),
                        ],
                      )),
                ],
              ))),
          Expanded(
            child: SingleChildScrollView(
              child: commentList == null
                  ? Container(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          child: Center(
                            child: Text("No Comment"),
                          )))
                  : Container(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: commentList.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(commentList[index]['username'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.brown,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            " (" +
                                                commentList[index]
                                                    ['datecomment'] +
                                                " )",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.brown,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    Text(commentList[index]['comment'],
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.brown)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              }))),
            ),
          ),
          TextField(
              controller: _commentcontroller,
              decoration: InputDecoration(
                  labelText: "Comment",
                  suffixIcon: IconButton(
                    onPressed: () {
                      _updatenewcomment();
                    },
                    icon: Icon(Icons.send),
                  ))),
        ]));
  }

  void _loadDetails() {
    print("Load cookies recipe");
    http.post("https://doubleksc.com/my_daily_cookies/php/load_recipe.php",
        body: {
          widget.recipess.name,
        }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        recipeList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          recipeList = jsondata["recipe"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadComment() {
    http.post("http://doubleksc.com/my_daily_cookies/php/load_review.php",
        body: {
          "name": widget.recipess.name,
        }).then((res) {
      print(res.body);

      if (res.body == "nodata") {
        print("Comment list is null");
        commentList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body);

          commentList = jsondata["comments"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _updatenewcomment() {
    final dateTime = DateTime.now();
    _comment = _commentcontroller.text;

    http.post("http://doubleksc.com/my_daily_cookies/php/add_review.php",
        body: {
          "name": recipes.name,
          "comment": _comment,
          "email": users.email,
          "username": users.name,
          "datecomment": "-${dateTime.microsecondsSinceEpoch}",
        }).then((res) {
      print(res.body);

      if (res.body == "success") {
        Toast.show("Successfully add comment.", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER,
            backgroundColor: Colors.brown);
      } else {
        Toast.show("Failed to add comment.", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER,
            backgroundColor: Colors.brown);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
