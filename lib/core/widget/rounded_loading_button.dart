import 'package:flutter/material.dart';
import '../common/globals.dart';
import '../pallete/theme.dart';
import '../../features/login/screen/splash_screen.dart';

class RoundedLoadingButton extends StatefulWidget {
  final String text;
  final bool isLoading;
  final bool icon;
  final Function onPressed;
  Color? backgroundColor = Colors.white;
  Color? TextColor = Colors.black;

  RoundedLoadingButton(
      {super.key, required this.text,
      required this.isLoading,
      required this.onPressed,
      this.backgroundColor,
      this.TextColor,
      required this.icon});

  @override
  _RoundedLoadingButtonState createState() => _RoundedLoadingButtonState();
}

class _RoundedLoadingButtonState extends State<RoundedLoadingButton> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: w * 0.025,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : () => widget.onPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(w * 0.008),
          ),
        ),
        child: widget.icon == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.add,
                    color: Palette.whiteColor,
                    size: w * 0.01,
                  ),
                  widget.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          widget.text,
                          style: TextStyle(
                              color: widget.TextColor, fontSize: w * 0.01),
                        ),
                ],
              )
            : widget.isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    widget.text,
                    style: TextStyle(color: widget.TextColor),
                  ),
        //   CustomTextWidget(text: widget.text,)
      ),
    );
  }
}
