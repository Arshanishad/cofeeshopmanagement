
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/common/error_text.dart';
import '../../../../../core/common/loader.dart';
import '../../../core/common/globals.dart';
import '../../login/controller/login_controller.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {


  logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.watch(loginControllerProvider.notifier).logout(context);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.nunitoSans(
              color: Colors.white,
              fontSize: h * 0.03,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Consumer(builder: (context, ref, child) {
          return ref.watch(getUserProvider(currentUserID)).when(
            data: (data) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.cyan,
                      radius: w * 0.15,
                      backgroundImage:
                      const AssetImage("assets/images/profilepic.jpg"),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Container(
                    height: h * 0.06,
                    width: w * 0.85,
                    decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius:
                        BorderRadius.circular(w * 0.02)),
                    child: Center(
                      child: Text("Name : ${data?.name}",
                          style: TextStyle(
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.002,
                  ),
                  Container(
                    height: h * 0.06,
                    width: w * 0.85,
                    decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius:
                        BorderRadius.circular(w * 0.02)),
                    child: Center(
                        child: Text("Phone no : ${data?.phoneNumber}",
                            style: TextStyle(
                                fontSize: w * 0.04,
                                fontWeight: FontWeight.w500))),
                  ),

                  SizedBox(height: h*0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          logOut(context);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.logout, color: Colors.black ),
                            SizedBox(width: 8),
                            Text("Logout", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              );
            },
            error: (error, stackTrace) =>
                ErrorText(error: error.toString()),
            loading: () => const Loader(),
          );
        }),
      ),
    );
  }

}