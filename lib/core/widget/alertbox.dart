import 'package:flutter/material.dart'; // Example import for Flutter widgets
import 'package:flutter/painting.dart'; // Example import for painting related classes
import 'package:flutter/rendering.dart';
 // Example import for rendering related classes


class ConfirmationDialog extends StatelessWidget {
  final Function onConfirmed;
  final Function onCancel;
  final String message;

  const ConfirmationDialog({super.key,
    required this.onConfirmed,
    required this.onCancel,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return AlertDialog(
      content: Text(
        message,
        style:TextStyle(
        // GoogleFonts.urbanist(
          fontSize: h * 0.02,
          fontWeight: FontWeight.w600,
          color: Colors.black, // Update color as needed
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => onCancel(),
          child:
          Text(
            'Cancel',
            style:TextStyle
            // GoogleFonts.urbanist
              (
              fontSize: h * 0.018,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            onConfirmed();
            Navigator.pop(context);
          },
          child:
          Text(
            'Confirm',
            style: TextStyle(
            // GoogleFonts.urbanist(
              fontSize: h * 0.018,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Update color as needed
            ),
          ),
        ),
      ],
    );
  }
}

// To use the widget, you can call it like this:

// DeleteConfirmationDialog(
//   onDeleteConfirmed: () {
//     // Handle delete confirmation
//   },
//   onCancel: () {
//     // Handle cancel action
//   },
//   message: 'Do you Want to Delete ?',
// )
