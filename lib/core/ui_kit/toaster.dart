// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/material.dart';

// void showToaster(
//     {required String message,
//     Color bgColor = Colors.red,
//     Color textColor = Colors.white}) {
//   Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: bgColor,
//       textColor: textColor,
//       fontSize: 16.0);
// }

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Consider using fluttertoast for easy toast messages

void showToaster({required String message, Color bgColor = Colors.green, Color textColor = Colors.white}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: bgColor,
    textColor: textColor,
    fontSize: 16.0,
  );
}
