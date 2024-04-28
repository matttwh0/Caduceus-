// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:finalproject/textbox.dart';
//import 'package:camera/camera.dart';
//import 'package:flutter_experiment/camera_page.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

@override 
State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State <HomePage> {

@override
Widget build(BuildContext context) {
  return Scaffold(
        //title - top section
        appBar: AppBar(title: Text("Caduceus"),
          backgroundColor: const Color.fromARGB(255, 137, 201, 139),
          leading: Icon(Icons.menu),
        ),
        body: Textbox(),
        
       );
       
  }
}


