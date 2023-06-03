import 'package:deneme/notificationManager.dart';
import 'package:deneme/widgets/round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountDownPage extends StatefulWidget {
  const CountDownPage({Key? key}) : super(key: key);

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage>
    with TickerProviderStateMixin {
  final NotificationManager notificationManager = NotificationManager();

  final TextEditingController textFieldController = TextEditingController();

  late AnimationController controller;

  bool isPlaying = false;

  int count = 0;

  int? countPut;

  String? valueText;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return "${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, "0")}:${(count.inSeconds % 60).toString().padLeft(2, "0")}";
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: count),
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed && controller.value == 0.0) {
          notificationManager.simpleNotificationShow();
        }
      });

    notificationManager.initNotification(); // Bildirim yöneticisini başlat
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    notificationManager.dispose(); // Bildirim yöneticisini kapat
  }

  void geriSar() {
    controller.reset();
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: geriSar,
            icon: Icon(Icons.restore),
            iconSize: 40,
            color: Colors.green,
          ),
          GestureDetector(
            onTap: () {},
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) => Text(
                countText,
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Sayaç"),
                        content: TextField(
                          onChanged: (value) {
                            valueText = value;
                          },
                          controller: textFieldController,
                          decoration: InputDecoration(hintText: "Sayı Giriniz"),
                        ),
                        actions: [
                          MaterialButton(
                            child: Text("Tamam"),
                            onPressed: () {
                              setState(() {
                                count =
                                    int.tryParse(textFieldController.text) ?? 0;
                                controller.duration = Duration(seconds: count);
                                controller.reverse(
                                  from: 1.0,
                                );
                                isPlaying = true;
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.alarm_add,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
