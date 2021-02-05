import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_daily_cookies/cookies.dart';
import 'package:my_daily_cookies/user.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class AddCommentScreen extends StatefulWidget {
  final Cookies cookies;
  final User user;

  const AddCommentScreen({Key key, this.cookies, this.user}) : super(key: key);
  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  double screenWidth, screenHeight;
  final TextEditingController _reviewcontroller = TextEditingController();
  String _review = "";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.cookies.name,
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
        ),
        body: Container(
            child: Padding(
                padding: EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          height: screenHeight / 4.2,
                          width: screenWidth / 2,
                          child: CachedNetworkImage(
                            imageUrl:
                                "http://doubleksc.com/my_daily_cookies/images/cookiesimages/${widget.cookies.image}.jpg",
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(
                              Icons.broken_image,
                              size: screenWidth / 2,
                            ),
                          )),
                      TextField(
                          controller: _reviewcontroller,
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown),
                          decoration: InputDecoration(
                              labelText: 'Fill in your comment',
                              icon: Icon(Icons.comment))),
                      SizedBox(height: 10),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Add a comment',
                            style: TextStyle(fontSize: 16)),
                        color: Colors.brown,
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: _onReviewDialog,
                      ),
                    ],
                  ),
                ))));
  }

  void _onReviewDialog() {
    _review = _reviewcontroller.text;
    if (_review == "") {
      Toast.show(
        "Please fill in your comment",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        backgroundColor: Colors.brown,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Comment for " + widget.cookies.name,
            style: TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure you want to add this comment?",
            style: TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addReview();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addReview() {
    http.post("http://doubleksc.com/my_daily_cookies/php/add_comment.php",
        body: {
          "image": widget.cookies.image,
          "cookiesname": widget.cookies.name,
          "email": widget.user.email,
          "name": widget.user.name,
          "review": _reviewcontroller.text,
        }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Add comment successfully.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
          backgroundColor: Colors.brown,
        );
        Navigator.pop(context);
      } else {
        Toast.show(
          "Failed to add comment.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
          backgroundColor: Colors.brown,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }
}
