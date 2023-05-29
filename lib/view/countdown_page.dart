import 'package:deneme/notificationManager.dart';
import 'package:deneme/widgets/round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountDownPage extends StatefulWidget {
  const CountDownPage({super.key});

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage>
    with TickerProviderStateMixin {
  late AnimationController controller;

  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return "${count.inHours}: ${(count.inMinutes % 60).toString().padLeft(2, "0")}:${(count.inSeconds % 60).toString().padLeft(2, "0")}";
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void geriSar() {
    controller.reset();
    controller.reverse(from: 1.0);
    setState(() {
      isPlaying = true;
    });
  }

  void showNotificationIfZero() {
    if (controller.value == 0) {
      NotificationManager().simpleNotificationShow();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                              height: 300,
                              child: CupertinoTimerPicker(
                                onTimerDurationChanged: (time) {
                                  setState(() {
                                    controller.duration = time;
                                  });
                                },
                              ),
                            ));
                  },
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (contexti, child) => Text(
                      countText,
                      style: const TextStyle(
                          fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (controller.isAnimating) {
                        controller.stop();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        controller.reverse(
                            from:
                                controller.value == 0 ? 1.0 : controller.value);
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                    child: RoundButton(
                      icon: isPlaying == true ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.reset();
                      setState(() {
                        isPlaying = false;
                      });
                    },
                    child: const RoundButton(icon: Icons.stop),
                  ),
                  GestureDetector(
                    onTap: geriSar,
                    child: const RoundButton(icon: Icons.restore),
                  ),
                  IconButton(
                    onPressed: () {
                      NotificationManager().simpleNotificationShow();
                    },
                    icon: const Icon(Icons.abc),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
