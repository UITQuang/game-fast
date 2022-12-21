import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
// import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:game/ui/start.dart';
import 'dart:math';
import 'package:async/async.dart';
import 'package:hive/hive.dart';

class PlayingPage extends StatefulWidget {
// const  PlayingPage({Key? key}) : super(key: key);
  double sizeWidth;

  PlayingPage({super.key, required this.sizeWidth});

  @override
  State<PlayingPage> createState() => _PlayingPageState();
}

class _PlayingPageState extends State<PlayingPage> {
  final CountdownController _controller = CountdownController(autoStart: true);
  var box = Hive.box('userBox');
  double timeOnPause = 0;
  double score = 0;
  late double d1 = widget.sizeWidth * 0.5;
  late double d2 = d1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                  Countdown(
                      controller: _controller,
                      seconds: 10,
                      build: (_, double time) {
                        timeOnPause = time;
                        return Text(
                          time.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        );
                      },
                      interval: const Duration(milliseconds: 100),
                      onFinished: () {
                        _showDialog('Your score: ${score.toStringAsFixed(1)}');
                      }),
                  const Expanded(child: SizedBox()),
                  Text(
                    'Your score: ${score.toStringAsFixed(1)}',
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
              AudioPlayer().play(AssetSource('audio/ting.mp3'));
              _controller.restart();
              setState(() {
                score = score + (timeOnPause * 1);
              });
            } else {
              AudioPlayer().play(AssetSource('audio/wrong.mp3'));
              _controller.pause();
              if (box.get("highScore") == null) {
                box.put("highScore", score.toStringAsFixed(1).toString());
              } else {
                if (score > double.parse(box.get("highScore"))) {
                  box.put("highScore", score.toStringAsFixed(1).toString());
                }
              }
              _showDialog('Your score: ${score.toStringAsFixed(1)}');
            }
          },
          child: ClipOval(
            child: Container(
              height: size1,
              width: size1,
              decoration: BoxDecoration(
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.grey, width: 1.5),
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
              AudioPlayer().play(AssetSource('audio/ting.mp3'));
              _controller.restart();
              setState(() {
                score = score + (timeOnPause * 1);
              });
            } else {
              AudioPlayer().play(AssetSource('audio/wrong.mp3'));
              _controller.pause();
              if (box.get("highScore") == null) {
                box.put("highScore", score.toStringAsFixed(1).toString());
              } else {
                if (score > double.parse(box.get("highScore"))) {
                  box.put("highScore", score.toStringAsFixed(1).toString());
                }
              }
              _showDialog('Your score: ${score.toStringAsFixed(1)}');
            }
          },
          child: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.grey, width: 1.5),
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
