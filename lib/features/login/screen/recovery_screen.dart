import 'package:coffee_shop_management/core/pallete/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/globals.dart';

class RecoveryScreen extends ConsumerStatefulWidget {
  const RecoveryScreen({Key? key}) : super(key: key);

  @override
  _RecoveryScreenState createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends ConsumerState<RecoveryScreen> {
  TextEditingController codeController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final isLoadingProvider=StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.02),
              Text(
                "Recover Password",
                style: TextStyle(
                  fontSize: h * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: h * 0.04),
              Text(
                "Enter the code sent to your email and set a new password.",
                style: TextStyle(
                  fontSize: h * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: h * 0.02),
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Recovery Code',
                ),
              ),
              SizedBox(height: h * 0.02),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'New Password',
                ),
              ),
              SizedBox(height: h * 0.02),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm New Password',
                ),
              ),
              SizedBox(height: h * 0.04),
              ref.watch(isLoadingProvider)
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(h * 0.07),
                  backgroundColor: Palette.lightRedColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(h * 0.01),
                  ),
                ),
                child: Text(
                  "Set New Password",
                  style: TextStyle(
                    fontSize: h * 0.025,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetPassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }
ref.watch(isLoadingProvider.notifier).update((state) => true);

    try {
      String email = FirebaseAuth.instance.currentUser!.email!;
      String code = codeController.text.trim();
      String newPassword = newPasswordController.text.trim();
      await _auth.verifyPasswordResetCode(code);
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password has been reset")),
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    } finally {
      ref.watch(isLoadingProvider.notifier).update((state) => false);
    }
  }
}
