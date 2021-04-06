import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eatporkshop/screen/home.dart';

Future<Null> signOutProcess() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();

  // ปิดแอป
  //exit(0);

  MaterialPageRoute route = MaterialPageRoute(
    builder: (context) => Home(),
  );
  BuildContext context;
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
}
