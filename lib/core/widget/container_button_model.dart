import 'package:flutter/material.dart';

class ContainerButtonModel extends StatefulWidget {
  final Color? bgColor;
  final double? containerWidth;
  final String itext;

  ContainerButtonModel({
    Key? key,
    this.bgColor,
    this.containerWidth,
    required this.itext,
  }) : super(key: key);

  @override
  State<ContainerButtonModel> createState() => _ContainerButtonModelState();
}

class _ContainerButtonModelState extends State<ContainerButtonModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: widget.containerWidth,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(widget.itext, style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 18)), // Displaying the text
      ),
    );
  }
}
