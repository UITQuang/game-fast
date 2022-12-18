import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game/ui/start.dart';
import 'dart:math';

import 'package:hive/hive.dart';

class PlayingPage extends StatefulWidget {
// const  PlayingPage({Key? key}) : super(key: key);
  double sizeWidth;

  PlayingPage({super.key, required this.sizeWidth});

  @override
  State<PlayingPage> createState() => _PlayingPageState();
}

class _PlayingPageState extends State<PlayingPage> {
  var box = Hive.box('userBox');

  int score = 0;
  late double d1 = widget.sizeWidth * 0.5;
  late double d2 = d1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Time: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    "Your score: $score",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              oval(d1 + Random().nextInt(50), d2 + Random().nextInt(50)),
            ],
          ),
        ),
      ),
    );
  }

  Widget oval(double size1, double size2) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (size1 > size2) {
              setState(() {
                score += 5;
              });
            } else {
             if(box.get("highScore")==null){
               box.put("highScore", score.toString());
             }
             else{
               if (score > int.parse(box.get("highScore"))) {
                 box.put("highScore", score.toString());
               }
             }
              _showDialog("Your score: $score");
            }
          },
          child: ClipOval(
            child: Container(
              height: size1,
              width: size1,
              decoration: BoxDecoration(
                color: Colors
                    .primaries[Random().nextInt(Colors.primaries.length)],
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.grey, width:1.5 ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        GestureDetector(
          onTap: () {
            if (size1 < size2) {
              setState(() {
                score += 5;
              });
            } else {
              if(box.get("highScore")==null){
                box.put("highScore", score.toString());
              }
              else{
                if (score > int.parse(box.get("highScore"))) {
                  box.put("highScore", score.toString());
                }
              }
              _showDialog("Your score: $score");
            }
          },
          child: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
    borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.grey, width:1.5 ),
         ),
              height: size2,
              width: size2,
            ),
          ),
        ),
      ],
    );
  }

  _showDialog(String content) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Finished"),
            content: Text(content),
            actions: <Widget>[
              OutlinedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const StartPage()),
                      (route) => false),
                  child: const Text("Close"))
            ],
          );
        });
  }
}
