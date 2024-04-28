// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


class Textbox extends StatefulWidget {
  Textbox({Key? key}) : super(key: key);

  @override
  _TextboxState createState() => _TextboxState();
}

class _TextboxState extends State<Textbox> {
  List<String> messages = [];
  final myController = TextEditingController();

//print the function to display user input
  void printBubble() {
    String message = myController.text;
    setState(() {
      messages.add(message);
      myController.clear(); 
    });
  }
//dispose of userinput in case new one comes
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

// take user input, display user input similar to chatbot
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 20), 
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(right: 16),
          ),
        ),
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Container(
                //spacing stuff
                margin: EdgeInsets.fromLTRB(64, 8, 16, 8), 
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  messages[index],
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
        Container(
          color: Colors.grey,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  //variable for user input
                  controller: myController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'How may I assist',
                  ),
                ),
              ),
              //button for when user clicks "send"
              ElevatedButton(
                onPressed: printBubble,
                child: Text("send"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
