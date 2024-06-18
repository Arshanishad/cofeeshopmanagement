import 'package:coffee_shop_management/core/pallete/theme.dart';
import 'package:coffee_shop_management/features/login/controller/login_controller.dart';
import 'package:coffee_shop_management/features/login/screen/recovery_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/globals.dart';
class ForgotScreen extends ConsumerStatefulWidget {
  const ForgotScreen({super.key});

  @override
  ConsumerState<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends ConsumerState<ForgotScreen> {
  passwordReset({required String email}){
    ref.read(loginControllerProvider.notifier).passwordReset(email: email);
  }
  bool clrButton=false;
  TextEditingController emailController=TextEditingController();
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
            children: [
              SizedBox(height:  h * 0.01),
              Align(
                alignment: Alignment.topLeft,
                child:  Text("Forgot Password",style: TextStyle(fontSize: h * 0.04, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: h * 0.07,),
              Text("Please enter your email address.You will receive a link to create or set a new password via email ",
                style: TextStyle(fontSize: h * 0.02, fontWeight: FontWeight.bold),),
              SizedBox(height: h * 0.02,),
              TextFormField(
                  controller: emailController,
                  onChanged: (val){
                    if(val != ""){
                      setState(() {
                        clrButton=true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                    ),
                    labelText: 'Email',
                    suffixIcon: InkWell(
                        onTap: (){
                          setState(() {
                            emailController.clear();
                          });
                        },
                        child: const Icon(CupertinoIcons.multiply,color: Palette.darkRedColor,)),
                  )
              ),
              SizedBox(height: h * 0.06),
              ElevatedButton(
                onPressed: (){
                  passwordReset(email: emailController.text.trim());
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const RecoveryScreen()));

                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(h * 0.07),
                  backgroundColor: Palette.redLightColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(h * 0.0),
                  ),
                ), child:Text("Send Code",style: TextStyle(
                fontSize: h * 0.025,
              ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
