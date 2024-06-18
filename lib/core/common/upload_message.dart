

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/login/screen/splash_screen.dart';
import 'globals.dart';


// void showSnackBar({required BuildContext context,required String text,required bool color}){
//   ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(text)));
// }



void showSnackBar({
  required BuildContext context,
  required String text,
  required bool color,
}) {
  final snackBar = SnackBar(
    content: Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: h * 0.1,
            width: w / 4,
            decoration: BoxDecoration(
              color: color ? Color(0xffC72C41) : Colors.green.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const SizedBox(width: 80),
                Expanded(
                  child: Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: w * 0.012),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
              child: Icon(
                Icons.bubble_chart,
                size: 48,
                color: color ? Color(0xff801336) : Colors.green.shade600,
              ),
            ),
          ),
          Positioned(
            top: -15,
            left: 10,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  CupertinoIcons.chat_bubble_fill,
                  color: color ? Color(0xff801336) : Colors.green.shade600,
                  size: 35,
                ),
                Positioned(
                  left: 8,
                  top: 5,
                  child: Icon(
                    color ? Icons.clear : Icons.done,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showAlertDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}










