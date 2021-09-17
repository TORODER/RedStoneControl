import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redstone_remote_control/api.dart';
import 'package:redstone_remote_control/tool/persist.dart';

import 'main_con.dart';

class SwitchTargetIp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SwitchTargetIpState();
  }
}

class SwitchTargetIpState extends State<SwitchTargetIp> {
  showEditTargetIp() {
    showDialog(
        context: context,
        builder: (bc) {
          TextEditingController textEditingController = TextEditingController();

          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(
              0,
              8,
              0,
              0,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: SizedBox(
                    child: ListTile(
                      leading: Text("ConTargetIp: "),
                      title: TextField(
                        scrollPadding: EdgeInsets.all(1),
                        controller: textEditingController,
                      ),
                    ),
                    height: 40,
                  ),
                ),
                SizedBox(
                  child: kIsWeb
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (bc){
                              return MainCon(targetIp: textEditingController.text);
                            }));
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                          child: Text("连接"),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Future(() async {
                              final resPersist = await Persist.usePersist(
                                  "UseTarGetIpList", "[]");
                              final resData =
                                  List<String>.from(await resPersist.read());
                              resData.add(textEditingController.text);
                              resPersist.save(jsonEncode(resData));
                            }).then((value) => setState(() => null));
                          },
                          child: Text("保存")),
                  height: 30,
                  width: double.infinity,
                )
              ],
            ),
          );
        });
  }

  Future<bool> test(String host) async {
    try {
      final res =
          await (new Dio(BaseOptions(sendTimeout: 1500, connectTimeout: 1500)))
              .getUri(ApiConfig.createTargetUri(host, path: "/test"));
      print(res.data);
      if (res.data is String) {
        return Future.value(res.data == "Hello");
      }
    } on Exception catch (e) {
      print(e);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        onPressed: () {
          showEditTargetIp();
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: Future(() async {
          final resPersist = await Persist.usePersist("UseTarGetIpList", "[]");
          final resData = List<String>.from(await resPersist.read());
          return resData;
        }),
        builder: (bc, futureState) {
          if (futureState.hasError) {
            print(futureState.error);
            return Text(futureState.error.toString());
          }
          if (futureState.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: (futureState.data as List<String>).length,
                  itemBuilder: (BuildContext context, int index) {
                    final resDataList = futureState.data as List<String>;
                    return ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (bc) {
                          return MainCon(targetIp: resDataList[index]);
                        }));
                      },
                      leading: Icon(Icons.phone_android),
                      title: Text("${resDataList[index]}"),
                      trailing: FutureBuilder(
                        future: test(resDataList[index]),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return Icon(
                              Icons.close,
                              color: Colors.red,
                            );
                          }
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return CircularProgressIndicator(
                              strokeWidth: 1,
                            );
                          }
                          if (snapshot.data ?? false) {
                            return Icon(
                              Icons.done,
                              color: Colors.green,
                            );
                          } else {
                            return Icon(
                              Icons.close,
                              color: Colors.red,
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
