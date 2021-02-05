import 'package:flutter/material.dart';
import 'package:my_daily_cookies/loginscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();
  final TextEditingController _phcontroller = TextEditingController();

  String _email = "";
  String _password = "";
  String _name = "";
  String _phone = "";
  bool _passwordVisible = false;
  bool _rememberMe = false;
  bool _termsCondition = false;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.brown),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Registration',
              style: TextStyle(fontSize: 17, color: Colors.white)),
        ),
        body: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(15.0),
            child: new Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: registrationPart(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget registrationPart(BuildContext context) {
    return new Container(
      child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/mydailycookies.png',
                  scale: 2,
                ),
                Container(
                    child: TextFormField(
                  controller: _namecontroller,
                  validator: validateName,
                  onSaved: (String val) {
                    _name = val;
                  },
                  decoration: InputDecoration(
                      labelText: 'Name', icon: Icon(Icons.person)),
                  keyboardType: TextInputType.name,
                  style: TextStyle(fontSize: 16, color: Colors.brown),
                )),
                Container(
                    child: TextFormField(
                  controller: _emcontroller,
                  validator: validateEmail,
                  onSaved: (String val) {
                    _email = val;
                  },
                  decoration: InputDecoration(
                      labelText: 'Email', icon: Icon(Icons.email)),
                  keyboardType: TextInputType.name,
                  style: TextStyle(fontSize: 16, color: Colors.brown),
                )),
                Container(
                    child: TextFormField(
                  controller: _phcontroller,
                  validator: validatePhone,
                  onSaved: (String val) {
                    _phone = val;
                  },
                  decoration: InputDecoration(
                      labelText: 'Phone Number', icon: Icon(Icons.phone)),
                  keyboardType: TextInputType.name,
                  style: TextStyle(fontSize: 16, color: Colors.brown),
                )),
                Container(
                    child: TextFormField(
                  controller: _pscontroller,
                  validator: validatePassword,
                  onSaved: (String val) {
                    _password = val;
                  },
                  style: TextStyle(fontSize: 16, color: Colors.brown),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: _passwordVisible,
                )),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _termsCondition,
                      onChanged: (bool value) {
                        _onChange(value);
                      },
                    ),
                    GestureDetector(
                        onTap: _showEULA,
                        child: Text.rich(TextSpan(
                            text: 'I agree the ',
                            style: TextStyle(fontSize: 16, color: Colors.brown),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'terms condition',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: '.',
                              ),
                            ])))
                  ],
                ),
                SizedBox(height: 10),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 300,
                  height: 50,
                  child: Text('Register', style: TextStyle(fontSize: 16)),
                  color: Colors.brown,
                  textColor: Colors.white,
                  elevation: 15,
                  onPressed: _newRegister,
                ),
                SizedBox(height: 10),
                GestureDetector(
                    onTap: _onLogin,
                    child: Text('Already register',
                        style: TextStyle(fontSize: 16, color: Colors.brown))),
              ],
            ),
          )),
    );
  }

  void _onRegister() async {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    _phone = _phcontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registration...");
    await pr.show();
    http.post(
        "https://www.doubleksc.com/my_daily_cookies/php/PHPMailer/index.php",
        body: {
          "name": _name,
          "email": _email,
          "password": _password,
          "phone": _phone,
        }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Registration success. An OTP verification email has been sent to $_email. Please verify your account.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
          backgroundColor: Colors.brown,
        );
        if (_rememberMe) {
          savepref();
        }
        _onLogin();
      } else {
        Toast.show(
          "Registration failed.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
          backgroundColor: Colors.brown,
        );
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  String validateName(String value) {
    if (value.length == 0) {
      return "Name is required.";
    }
    return null;
  }

  String validatePhone(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Phone number is required.";
    } else if (!regExp.hasMatch(value)) {
      return "Phone number must be in digits only.";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is required.";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid email.";
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is required.";
    }
    return null;
  }

  void _onLogin() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _termsCondition = value;
    });
  }

  void savepref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    await prefs.setString('email', _email);
    await prefs.setString('password', _password);
    await prefs.setBool('rememberme', true);
  }

  void _newRegister() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    _phone = _phcontroller.text;

    if (!_termsCondition) {
      Toast.show(
        "Please fill in all the required fields.",
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
            "Register",
            style: TextStyle(
                color: Colors.brown, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure you want to register a new account ?",
            style: TextStyle(color: Colors.brown, fontSize: 16),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _onRegister();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.brown,
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

  void _showEULA() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: new Text(
            "End-User License Agreement (EULA) of My Daily Cookies",
            style: TextStyle(color: Colors.brown),
          ),
          content: new Container(
            height: 400,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.brown,
                            fontSize: 11.0,
                          ),
                          text:
                              "This End-User License Agreement is a legal agreement between you and Doubleksc. This EULA agreement governs your acquisition and use of our My Daily Cookies software (Software) directly from Doubleksc or indirectly through a Doubleksc authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the My Daily Cookies software. It provides a license to use the My Daily Cookies software and contains warranty information and liability disclaimers. If you register for a free trial of the My Daily Cookies software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the My Daily Cookies software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by Doubleksc herewith regardless of whether other software is referred to or described herein. The terms also apply to any Doubleksc updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for My Daily Cookies. Doubleksc shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Doubleksc. Doubleksc reserves the right to grant licences to use the Software to third parties.",
                        )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.brown),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
