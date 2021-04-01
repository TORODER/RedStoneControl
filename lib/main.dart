import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:redstone_remote_control/switch_target_ip.dart';

import 'main_con.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RRC',
      home: MyHomePage(title: 'RRC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconButton(onPressed: (){setState(() {});}, icon: Icon(Icons.refresh_sharp))],
      ),
      body: SwitchTargetIp(),
    );
  }
}
