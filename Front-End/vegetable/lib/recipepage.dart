import 'package:flutter/material.dart';
import 'underbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'mainpage.dart';



class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage>{


  @override
  Widget build(AboutDialog){
    return Scaffold(
      appBar: AppBar(
        title: Text("레시피",
        style: TextStyle(color: Colors.black,
        fontSize: 20),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [

        ]
        ),
    );
  }
}