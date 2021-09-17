import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:redstone_remote_control/api.dart';

class ConElem extends StatelessWidget {
  Widget showIcon;
  Function onDown;
  Function onUp;
  double? size;

  ConElem(
      {required this.onDown,
      required this.onUp,
      required this.showIcon,
      this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (t) {
        onDown();
      },
      onTapUp: (t) {
        onUp();
      },
      onTapCancel: () {
        onUp();
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        width: size ?? 100,
        height: size ?? 100,
        child: Center(
          child: Theme(
            data: ThemeData(
                iconTheme: IconThemeData(color: Colors.blue, size: 30)),
            child: showIcon,
          ),
        ),
      ),
    );
  }
}

class MainCon extends StatefulWidget {
  int leftMsg = 0;
  int leftSpeed = 0;
  int rightMsg = 0;
  int rightSpeed = 0;
  String targetIp = "172.16.5.12";

  MainCon({required this.targetIp});

  @override
  State<StatefulWidget> createState() {
    return MainConState();
  }
}

class MainConState extends State<MainCon> {
  setNullState() =>
      setMsg(newLeftMsg: 0, newRightMsg: 0, leftSpeed: 0, rightSpeed: 0);

  setMsg(
      {int? newLeftMsg,
      int? newRightMsg,
      int leftSpeed = 0,
      int rightSpeed = 0}) {
    if (newLeftMsg != null) {
      this.widget.leftMsg = newLeftMsg;
    }
    if (newRightMsg != null) {
      this.widget.rightMsg = newRightMsg;
    }
    this.widget.leftSpeed = leftSpeed;
    this.widget.rightSpeed = rightSpeed;
    sendState().then((value) => setState(() {}));
  }

  Future sendState() async {
    final sendState = [
      this.widget.leftMsg,
      this.widget.rightMsg,
      this.widget.leftSpeed,
      this.widget.rightSpeed
    ];
    final url =
        ApiConfig.createTargetUri(this.widget.targetIp, path: "/conCarRun");
    await new Dio(BaseOptions(sendTimeout: 500)).postUri(
      url,
      data: jsonEncode(
        sendState,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Row(
          children: [
            Column(
              children: [
                Text("当前目标Ip: ${this.widget.targetIp}"),
                Expanded(
                  child: Center(
                    child: FittedBox(
                      child: Container(
                        width: 280,
                        height: 280,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ConElem(
                                    showIcon: Icon(
                                      Icons.keyboard_arrow_up_sharp,
                                      size: 100,
                                    ),
                                    size: 100,
                                    onDown: () {
                                      setMsg(
                                          newLeftMsg: 1,
                                          newRightMsg: 1,
                                          leftSpeed: 255,
                                          rightSpeed: 255);
                                    },
                                    onUp: setNullState,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ConElem(
                                    showIcon: Icon(
                                        Icons.keyboard_arrow_left_sharp,
                                        size: 100),
                                    size: 100,
                                    onDown: () {
                                      setMsg(
                                          newLeftMsg: 1,
                                          newRightMsg: 1,
                                          leftSpeed: 255,
                                          rightSpeed: 50);
                                    },
                                    onUp: setNullState,
                                  ),
                                  ConElem(
                                    showIcon: Icon(
                                        Icons.keyboard_arrow_right_sharp,
                                        size: 100),
                                    size: 100,
                                    onDown: () {
                                      setMsg(
                                          newLeftMsg: 0,
                                          newRightMsg: 1,
                                          leftSpeed: 50,
                                          rightSpeed: 255);
                                    },
                                    onUp: setNullState,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ConElem(
                                    showIcon: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 100,
                                    ),
                                    size: 100,
                                    onDown: () {
                                      setMsg(
                                          newLeftMsg: -1,
                                          newRightMsg: -1,
                                          leftSpeed: 255,
                                          rightSpeed: 255);
                                    },
                                    onUp: setNullState,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
