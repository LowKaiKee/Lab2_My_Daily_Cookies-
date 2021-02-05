import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_daily_cookies/addrecipe.dart';
import 'package:my_daily_cookies/recipe.dart';
import 'package:my_daily_cookies/recipedetails.dart';
import 'package:my_daily_cookies/user.dart';

class SharedPost extends StatefulWidget {
  final User user;

  const SharedPost({Key key, this.user}) : super(key: key);
  @override
  _SharedPostState createState() => _SharedPostState();
}

class _SharedPostState extends State<SharedPost> {
  List recipeList;
  bool liked = false;
  double screenWidth, screenHeight;
  String titlecenter = "Loading cookies recipe ...";
  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Cookies recipe',
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                _addRecipe();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _loadRecipe();
              },
            ),
          ]),
      body: Column(
        children: [
          recipeList == null
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
                  childAspectRatio: (screenWidth / screenHeight) / 0.46,
                  children: List.generate(recipeList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: new BorderSide(
                                  color: Colors.grey[300], width: 1.0),
                            ),
                            child: InkWell(
                                onTap: () => _loadRecipeDetail(index),
                                child: SingleChildScrollView(
                                    child: Column(children: [
                                  Container(
                                      height: 200,
                                      width: 400,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://doubleksc.com/my_daily_cookies/images/cookiesimages/${recipeList[index]['image']}.jpg",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 80.0,
                                          height: 80.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                  Text(
                                    recipeList[index]['name'] + " recipe",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown),
                                  ),
                                  Text(
                                    " Posted by: " +
                                        recipeList[index]['username'],
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown),
                                  ),
                                ])))));
                  }),
                ))
        ],
      ),
    );
  }

  void _loadRecipe() {
    http.post("https://doubleksc.com/my_daily_cookies/php/load_recipe.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "no data") {
        recipeList = null;
        setState(() {
          titlecenter = "No data";
        });
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

  _loadRecipeDetail(int index) {
    Recipe recipe = new Recipe(
        id: recipeList[index]['id'],
        email: recipeList[index]['email'],
        username: recipeList[index]['username'],
        image: recipeList[index]['image'],
        name: recipeList[index]['name'],
        recipe: recipeList[index]['recipe']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                RecipeDetail(recipe, widget.user)));
  }

  void _addRecipe() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AddRecipe(user: widget.user)));
  }
}
