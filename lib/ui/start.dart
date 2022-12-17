import 'package:flutter/material.dart';
import 'package:game/ui/playping.dart';
import 'package:hive/hive.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  var box = Hive.box('userBox');

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 200.0),
              child: Text("No1 server : 99"),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => PlayingPage(
                                sizeWidth: sizeWidth,
                              )),
                      (route) => false);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 300),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.orange),
                  child: const Center(
                      child: Text(
                    "START",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: (box.get("highScore") != null)
                  ? Text('Your high score: ' + box.get("highScore"),style: TextStyle(fontSize: 18))
                  : const Text("Your high score: 0",style: TextStyle(fontSize: 18),),
            ),
          ],
        ),
      ),
    ));
  }
}
