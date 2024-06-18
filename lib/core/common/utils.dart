import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


// void showSnackBar(BuildContext context,String text){
//   ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(text)));
// }
void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}




