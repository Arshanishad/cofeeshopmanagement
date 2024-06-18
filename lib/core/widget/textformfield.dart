import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final double? width;
  final double? height;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onPrefixIconTap;
  final VoidCallback? onSuffixIconTap;
  final int? maxLines;
  final TextCapitalization textCapitalization;
  final bool? obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final Color? bgColour;
  final Color? borderColour;
  final Color? labelColour;

  const CustomTextInput({
    Key? key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onPrefixIconTap,
    this.onSuffixIconTap,
    this.maxLines,
    this.textCapitalization = TextCapitalization.none,
    this.width = 0.20,
    this.height = 0.08,
    this.bgColour,
    this.borderColour,
    this.labelColour,
    this.onChanged,
    this.obscureText = false,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;

    return Container(
      height: h * (height ?? 0.08),
      width: w * (width ?? 0.20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(w * 0.008),
        border: Border.all(color: Colors.transparent),
        color: bgColour ?? Colors.white, // Provide default color if bgColour is null
      ),
      child: TextFormField(
        style: TextStyle(fontSize: w * 0.05),
        obscureText: obscureText ?? false,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: Colors.black,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        controller: controller,
        maxLines: maxLines, // added maxLines
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(w * 0.01),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColour ?? Colors.grey), // Provide default color if borderColour is null
          ),
          label: Text(
            label,
            style: TextStyle(color: labelColour ?? Colors.grey, fontSize: w * 0.03), // Provide default color if labelColour is null
          ),
          prefixIcon: prefixIcon != null
              ? InkWell(
            onTap: onPrefixIconTap,
            child: Icon(prefixIcon),
          )
              : null,
          suffixIcon: suffixIcon != null
              ? InkWell(
            onTap: onSuffixIconTap,
            child: Icon(suffixIcon),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.008),
            borderSide: BorderSide(color: borderColour ?? Colors.grey), // Provide default color if borderColour is null
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.008),
            borderSide: BorderSide(color: borderColour ?? Colors.grey), // Provide default color if borderColour is null
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.008),
            borderSide: BorderSide(color: borderColour ?? Colors.grey), // Provide default color if borderColour is null
          ),
        ),
      ),
    );
  }
}