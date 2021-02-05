import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_daily_cookies/addcomment.dart';
import 'package:my_daily_cookies/commentstation.dart';
import 'package:my_daily_cookies/cookies.dart';
import 'package:my_daily_cookies/loginscreen.dart';
import 'package:my_daily_cookies/ordercookies.dart';
import 'package:my_daily_cookies/sellcookies.dart';
import 'package:my_daily_cookies/sharedrecipe.dart';
import 'package:my_daily_cookies/user.dart';
import 'package:my_daily_cookies/yourcart.dart';
import 'package:toast/toast.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List cookiesList;
  List userList;
  double screenWidth, screenHeight;
  String titlecenter = "Loading...";
  @override
  void initState() {
    super.initState();
    _loadCookies();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'My Daily Cookies',
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _loadCookies();
              },
            ),
          ]),
      // floatingActionButton: SpeedDial(
      //   animatedIcon: AnimatedIcons.menu_close,
      //   children: [
      //     SpeedDialChild(
      //         child: Icon(Icons.shop_sharp),
      //         label: "Sell your cookies",
      //         labelBackgroundColor: Colors.white,
      //         onTap: _sellCookies),
      //     SpeedDialChild(
      //         child: Icon(Icons.book),
      //         label: "Cookies recipes",
      //         labelBackgroundColor: Colors.white,
      //         onTap: _sharedPost),
      //     SpeedDialChild(
      //         child: Icon(Icons.comment),
      //         label: "Comment history",
      //         labelBackgroundColor: Colors.white,
      //         onTap: _loadComment),
      //     SpeedDialChild(
      //         child: Icon(Icons.logout),
      //         label: "Log out",
      //         labelBackgroundColor: Colors.white,
      //         onTap: logOutDialog),
      //   ],
      // ),
      drawer: new Drawer(
        child: new ListView(children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName:
                new Text(widget.user.name, style: TextStyle(fontSize: 16)),
            accountEmail:
                new Text(widget.user.email, style: TextStyle(fontSize: 16)),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.white,
              child: new Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart_rounded,
              color: Colors.brown,
            ),
            title: Text('Your cart',
                style: TextStyle(color: Colors.brown, fontSize: 16)),
            onTap: () {
              _cartScreen();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.comment,
              color: Colors.brown,
            ),
            title: Text('Comment station',
                style: TextStyle(color: Colors.brown, fontSize: 16)),
            onTap: () {
              _loadComment();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.book,
              color: Colors.brown,
            ),
            title: Text('Cookies recipe',
                style: TextStyle(color: Colors.brown, fontSize: 16)),
            onTap: () {
              _sharedPost();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.shop_sharp,
              color: Colors.brown,
            ),
            title: Text('Sell your cookies',
                style: TextStyle(color: Colors.brown, fontSize: 16)),
            onTap: () {
              _sellCookies();
            },
          ),
          Expanded(child: SizedBox(height: 50)),
          Divider(),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.brown,
                ),
                title: Text('Logout',
                    style: TextStyle(color: Colors.brown, fontSize: 16)),
                onTap: () {
                  logOutDialog();
                },
              ),
            ),
          ),
        ]),
      ),
      body: Column(
        children: [
          cookiesList == null
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
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 1.0,
                  children: List.generate(cookiesList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: new BorderSide(
                                  color: Colors.grey[350], width: 1.0),
                            ),
                            child: InkWell(
                                onTap: () => _loadCookiesDetail(index),
                                onLongPress: () => _deleteCookiesList(index),
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    Container(
                                        height: screenHeight / 4.2,
                                        width: screenWidth / 2,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://doubleksc.com/my_daily_cookies/images/cookiesimages/${cookiesList[index]['image']}.jpg",
                                          imageBuilder:
                                              (context, imageProvider) =>
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
                                    Positioned(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.star, color: Colors.brown),
                                          Text(cookiesList[index]['rating'],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.brown)),
                                          Icon(Icons.star, color: Colors.brown),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      cookiesList[index]['name'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown),
                                    ),
                                    Text(
                                      "Quantity: " +
                                          cookiesList[index]['quantity'] +
                                          ' packets',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown),
                                    ),
                                    Text(
                                      "RM  " +
                                          cookiesList[index]['price'] +
                                          ' each packet',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown),
                                    ),
                                    Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.brown)),
                                            color: Colors.brown,
                                            onPressed: () =>
                                                _commentScreen(index),
                                            child: Padding(
                                              padding: EdgeInsets.all(1),
                                              child: Text(
                                                "Comment",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.brown,
                                            ),
                                            onPressed: () {
                                              _loadCookiesDetail(index);
                                            },
                                          ),
                                        ]))
                                  ],
                                )))));
                  }),
                ))
        ],
      ),
    );
  }

  void _cartScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CartScreen(user: widget.user)));
  }

  void _loadCookies() {
    http.post("https://doubleksc.com/my_daily_cookies/php/load_cookies.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "no data") {
        cookiesList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          cookiesList = jsondata["cookies"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadCookiesDetail(int index) {
    Cookies cookies = new Cookies(
        image: cookiesList[index]['image'],
        id: cookiesList[index]['id'],
        name: cookiesList[index]['name'],
        price: cookiesList[index]['price'],
        quantity: cookiesList[index]['quantity'],
        rating: cookiesList[index]['rating']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailScreen(cookies: cookies, user: widget.user)));
  }

  void _commentScreen(int index) {
    print(cookiesList[index]['name']);
    Cookies cookies = new Cookies(
        image: cookiesList[index]['image'],
        id: cookiesList[index]['id'],
        name: cookiesList[index]['name']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AddCommentScreen(cookies: cookies, user: widget.user)));
  }

  void _sellCookies() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => SellCookies(user: widget.user)));
  }

  _deleteCookiesList(int index) {
    print("Delete " + cookiesList[index]['name']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Delete your cookies product",
            style: TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure you want to delete " +
                cookiesList[index]['name'] +
                "?",
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
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteCookiesProduct(index);
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

  void _deleteCookiesProduct(int index) {
    http.post("http://doubleksc.com/my_daily_cookies/php/delete_cookies.php",
        body: {
          "email": widget.user.email,
          "id": cookiesList[index]['id'],
        }).then((res) {
      print(res.body);
      if (res.body == "success") {
        // Toast.show(
        //   "Delete Success",
        //   context,
        //   duration: Toast.LENGTH_LONG,
        //   gravity: Toast.CENTER,
        //   backgroundColor: Colors.brown,
        // );
        _loadCookies();
      } else {
        Toast.show(
          "Delete Failed",
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

  void _sharedPost() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => SharedPost(user: widget.user)));
  }

  void _loadComment() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                LoadCommentScreen(user: widget.user)));
  }

  void _logOut() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void logOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Log out",
            style: TextStyle(
              color: Colors.brown,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure you want to log out ?",
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
                _logOut();
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
}
