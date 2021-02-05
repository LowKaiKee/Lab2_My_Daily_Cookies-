import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_daily_cookies/mainscreen.dart';
import 'package:my_daily_cookies/registerscreen.dart';
import 'package:my_daily_cookies/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKeyForResetEmail = GlobalKey<FormState>();
  final formKeyForResetPassword = GlobalKey<FormState>();
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();
  TextEditingController passResetController = new TextEditingController();
  TextEditingController emailForgotController = new TextEditingController();
  SharedPreferences prefs;
  String _email = "";
  String _password = "";
  bool _rememberMe = false;
  bool autoValidate = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Login',
                  style: TextStyle(fontSize: 17, color: Colors.white)),
            ),
            body: new Container(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/mydailycookies.png',
                      scale: 2,
                    ),
                    TextField(
                        controller: _emcontroller,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 16, color: Colors.brown),
                        decoration: InputDecoration(
                            labelText: 'Email', icon: Icon(Icons.email))),
                    TextField(
                      controller: _pscontroller,
                      style: TextStyle(fontSize: 16, color: Colors.brown),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: _passwordVisible,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool value) {
                            _onChange(value);
                          },
                        ),
                        Text('Remember me',
                            style: TextStyle(fontSize: 16, color: Colors.brown))
                      ],
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Login', style: TextStyle(fontSize: 17)),
                      color: Colors.brown,
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: _onLogin,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: _onRegister,
                        child: Text('Register new account',
                            style:
                                TextStyle(fontSize: 16, color: Colors.brown))),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: _onForgot,
                        child: Text('Forgot password',
                            style:
                                TextStyle(fontSize: 16, color: Colors.brown))),
                  ],
                ),
              ),
            )));
  }

  Future<void> _onLogin() async {
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    await pr.show();
    http.post("https://doubleksc.com/my_daily_cookies/php/login_user.php",
        body: {
          "email": _email,
          "password": _password,
        }).then((res) {
      print(res.body);
      List userdata = res.body.split(",");

      if (userdata[0] == "success") {
        Toast.show(
          "Login successful.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
          backgroundColor: Colors.brown,
        );
        User user = new User(
            email: _email,
            name: userdata[1],
            password: _password,
            phone: userdata[2],
            datereg: userdata[3]);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(user: user)));
      } else {
        Toast.show(
          "Login failed. Please check your email and password.",
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

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _onForgot() {
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Reset my password",
            style: TextStyle(color: Colors.brown),
          ),
          content: new Container(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter your email address: ",
                        style: TextStyle(
                            color: Colors.brown, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Form(
                        key: formKeyForResetEmail,
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email', icon: Icon(Icons.email)),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown),
                          validator: emailValidate,
                          onSaved: (String value) {
                            _email = value;
                          },
                        )),
                  ],
                ),
              )),
          actions: <Widget>[
            new FlatButton(
                child: new Text(
                  "Ok",
                  style: TextStyle(color: Colors.brown),
                ),
                onPressed: () {
                  if (formKeyForResetEmail.currentState.validate()) {
                    _passwordVisible = false;
                    emailForgotController.text = emailController.text;
                    _enterResetPass();
                  }
                }),
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(color: Colors.brown),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  void _enterResetPass() {
    TextEditingController passController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Text(
                "Reset my password",
                style:
                    TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
              ),
              content: new Container(
                  height: 100,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter your new password: ",
                            style: TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        Form(
                            key: formKeyForResetPassword,
                            child: TextFormField(
                                controller: passController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  icon: Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    child: Icon(_passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown),
                                obscureText: !_passwordVisible,
                                validator: passVisible,
                                onSaved: (String value) {
                                  _password = value;
                                }))
                      ],
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Reset",
                      style: TextStyle(
                          color: Colors.brown, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (formKeyForResetPassword.currentState.validate()) {
                        passResetController.text = passController.text;
                        _resetPassword();
                      }
                    }),
                new FlatButton(
                  child: new Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  String emailValidate(String value) {
    if (value.isEmpty) {
      return 'Email is required.';
    }

    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return 'Please enter a valid email address!';
    }

    return null;
  }

  String passVisible(String value) {
    if (value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < 5) {
      return 'Password length must be 5 digits above.';
    }
    return null;
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
      savepref(value);
    });
  }

  void loadpref() async {
    prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email')) ?? '';
    _password = (prefs.getString('password')) ?? '';
    _rememberMe = (prefs.getBool('rememberme')) ?? false;
    if (_email.isNotEmpty) {
      setState(() {
        _emcontroller.text = _email;
        _pscontroller.text = _password;
        _rememberMe = _rememberMe;
      });
    }
  }

  void savepref(bool value) async {
    prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;

    if (value) {
      if (_email.length < 5 && _password.length < 3) {
        print("Please fill in all the required fields.");
        _rememberMe = false;
        Toast.show(
          "Please fill in all the required fields.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
          backgroundColor: Colors.brown,
        );
        return;
      } else {
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        await prefs.setBool('rememberme', value);
        Toast.show(
          "Preferences saved",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
          backgroundColor: Colors.brown,
        );
        print("Preferences saved");
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('rememberme', false);
      setState(() {
        _emcontroller.text = "";
        _pscontroller.text = "";
        _rememberMe = false;
      });
      Toast.show(
        "Preferences removed",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        backgroundColor: Colors.brown,
      );
      print("Preferences removed");
    }
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }

  String passwordVisible(String value) {
    if (value.isEmpty) {
      return 'Password is Required';
    }

    if (value.length < 5) {
      return 'Password Length Must Be 5 Digits Above';
    }
    return null;
  }

  void _resetPassword() {
    String email = emailForgotController.text;
    String password = passResetController.text;
    final form = formKeyForResetPassword.currentState;

    if (form.validate()) {
      form.save();
      http.post("https://doubleksc.com/my_daily_cookies/php/reset_password.php",
          body: {
            "email": email,
            "password": password,
          }).then((res) {
        print(res.body);
        if (res.body.contains("success")) {
          Navigator.of(context).pop();
          Toast.show("Password reset successfully", context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.CENTER,
              backgroundColor: Colors.brown);
          Navigator.pop(context);
        } else {
          Toast.show("Password reset failed", context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.CENTER,
              backgroundColor: Colors.brown);
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }
}
