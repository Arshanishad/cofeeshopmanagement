import 'package:coffee_shop_management/core/constants/constants.dart';
import 'package:coffee_shop_management/core/pallete/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/common/globals.dart';
import '../controller/login_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  checkKeepLogin(){
    ref.read(loginControllerProvider.notifier).checkKeepLogin(context);
  }
  @override
  void initState() {
    checkKeepLogin();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    h=MediaQuery.of(context).size.height;
    w=MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 100,bottom: 40),
        height: h,
        width: w,
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(image: AssetImage(Constants.splashLogo),
            fit: BoxFit.cover,
            opacity: 0.6,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Coffee Shop",style: GoogleFonts.pacifico(
              fontSize: 50,
              color: Colors.white,
            ),),
            Column(
              children: [
                Text("Feeling Low? Take a Sip of Coffee",style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),),
                SizedBox(height: 80),
                InkWell(
                  splashColor: Colors.black,
                  onTap: (){

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 35 ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Get Started"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
