import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_daily_cookies/cookies.dart';
import 'package:my_daily_cookies/user.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final Cookies cookies;
  final User user;

  const DetailScreen({Key key, this.cookies, this.user}) : super(key: key);
  @override
  _DetailScreen createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  final TextEditingController _remarkscontroller = TextEditingController();
  double screenWidth, screenHeight;
  int selectedQuantity;
  String _remarks = "";
  List cookiesList;

  @override
  Widget build(BuildContext context) {
    var quantity =
        Iterable<int>.generate(int.parse(widget.cookies.quantity) + 1).toList();
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
                          )
                          ),
                      Row(
                        children: [
                          Icon(Icons.confirmation_number),
                          SizedBox(width: 20),
                          Container(
                            height: 50,
                            child: DropdownButton(
                              hint: Text(
                                'Quantity',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown),
                              ),
                              value: selectedQuantity,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedQuantity = newValue;
                                  print(selectedQuantity);
                                });
                              },
                              items: quantity.map((selectedQuantity) {
                                return DropdownMenuItem(
                                  child: new Text(selectedQuantity.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown)),
                                  value: selectedQuantity,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      TextField(
                          controller: _remarkscontroller,
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown),
                          decoration: InputDecoration(
                              labelText: 'Your remark',
                              icon: Icon(Icons.notes))),
                      SizedBox(height: 10),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child:
                            Text('Add to cart', style: TextStyle(fontSize: 16)),
                        color: Colors.brown,
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: _onOrderDialog,
                      ),
                    ],
                  ),
                ))));
  }

  void _onOrderDialog() {
    _remarks = _remarkscontroller.text;
    if (_remarks == "") {
      Toast.show("Fill in your remark", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
          backgroundColor: Colors.brown);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Add order",
            style: TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure you want to add order for " +
                selectedQuantity.toString() +
                " packet/s of " +
                widget.cookies.name +
                " ?",
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
                _orderCookies();
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

  void _orderCookies() {
    http.post("http://doubleksc.com/my_daily_cookies/php/add_order.php", 
    body: {
      "email": widget.user.email,
      "id": widget.cookies.id,
      "quantity": selectedQuantity.toString(),
      "remarks": _remarkscontroller.text,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Successfully add order.", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER,
            backgroundColor: Colors.brown);
        Navigator.pop(context);
      } else {
        Toast.show(
          "Failed to add order.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }
}
