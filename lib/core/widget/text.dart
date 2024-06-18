import 'package:flutter/material.dart';
import '../../features/login/screen/splash_screen.dart';
import '../common/globals.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final double fontSizeMultiplier;
  final Color color;
  final FontWeight weight;



  const CustomTextWidget({
    Key? key,
    required this.text,
    this.fontSizeMultiplier = 0.018,
    this.color= Colors.black,
    this.weight=FontWeight.bold ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Text(
      overflow: TextOverflow.ellipsis,
      text,
      style: TextStyle(
      // GoogleFonts.roboto(
        color: color,
        fontSize: h * fontSizeMultiplier,
        fontWeight: weight,
      ),
    );
  }
}
