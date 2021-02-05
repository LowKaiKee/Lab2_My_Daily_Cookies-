import 'dart:io';
import 'dart:convert';
import 'package:my_daily_cookies/user.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:my_daily_cookies/cookies.dart';

class SellCookies extends StatefulWidget {
  final Cookies cookies;
  final User user;

  const SellCookies({Key key, this.cookies, this.user}) : super(key: key);
  @override
  _SellCookiesState createState() => _SellCookiesState();
}

class _SellCookiesState extends State<SellCookies> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _pricecontroller = TextEditingController();
  final TextEditingController _quantitycontroller = TextEditingController();
  final TextEditingController _ratecontroller = TextEditingController();
  String cookiestype = "Cookies";
  String _name = "";
  String _price = "";
  String _quantity = "";
  String _rating = "";
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/camera.png';

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sell your cookies',
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () => {_onPictureSelection()},
                        child: Container(
                          height: screenHeight / 3.2,
                          width: screenWidth / 1.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              width: 3.0,
                              color: Colors.grey,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        )),
                    SizedBox(height: 5),
                    Text("Click here to upload your cookies image",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.brown)),
                    SizedBox(height: 5),
                    TextField(
                        controller: _namecontroller,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.brown),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Name of cookies',
                            icon: Icon(Icons.wysiwyg_rounded))),
                    SizedBox(height: 10),
                    TextField(
                        controller: _quantitycontroller,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.brown),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Quantity available',
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            icon: Icon(Icons.confirmation_number))),
                    SizedBox(height: 10),
                    TextField(
                        controller: _pricecontroller,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.brown),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Price of each packet',
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            icon: Icon(Icons.money_sharp))),
                    SizedBox(height: 10),
                    TextField(
                        controller: _ratecontroller,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.brown),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Rating',
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            icon: Icon(Icons.star))),
                    SizedBox(height: 10),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Add cookies to sell',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      color: Colors.brown,
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: newCookiesDialog,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ))),
    );
  }

  _onPictureSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                        color: Colors.brown,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                        color: Colors.brown,
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _chooseGallery(),
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _chooseCamera() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  void _chooseGallery() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.brown,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void newCookiesDialog() {
    _name = _namecontroller.text;
    _price = _pricecontroller.text;
    if (_name == "" && _price == "") {
      Toast.show(
        "Please fill all the required fields!",
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
            "Add new cookies to sell",
            style: TextStyle(
              color: Colors.brown,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure you want to add this cookies to sell?",
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
                _onAddCookies();
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

  void _onAddCookies() {
    _name = _namecontroller.text;
    _price = _pricecontroller.text;
    _quantity = _quantitycontroller.text;
    _rating = _ratecontroller.text;
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post("http://doubleksc.com/my_daily_cookies/php/add_cookies.php",
        body: {
          "email": widget.user.email,
          "name": _name,
          "price": _price,
          "quantity": _quantity,
          "encoded_string": base64Image,
          "rating": _rating,
        }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Successfully add cookies to sell.", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER,
            backgroundColor: Colors.brown);
        Navigator.pop(context);
      } else {
        Toast.show("Failed to add cookies to sell.", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER,
            backgroundColor: Colors.brown);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
