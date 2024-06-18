import 'package:coffee_shop_management/core/widget/alertbox.dart';
import 'package:coffee_shop_management/features/login/screen/signup_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/globals.dart';
import '../../../core/common/upload_message.dart';
import '../../../core/constants/constants.dart';
import '../../../core/pallete/theme.dart';
import '../../../core/widget/rounded_loading_button.dart';
import '../../../core/widget/textformfield.dart';
import '../controller/login_controller.dart';
import 'forgot_password.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final eyeBool=StateProvider((ref) => false);
  login() async {
    if(_formKey.currentState!.validate()) {
      ref.read(loginControllerProvider.notifier).login(email: emailController.text.trim(),
          password: passwordController.text.trim(), context: context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child:Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   SizedBox(height: h*0.1,),
                  Image.asset(Constants.loginImage),
                   SizedBox(height: h*0.05,),
                  Align(
                    alignment: Alignment.bottomRight,
                    child:
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgotScreen()));
                    }, child:  Text("Forgot Password",style: TextStyle(fontSize: w*0.04,
                        color: Palette.redLightColor,fontWeight: FontWeight.w600),)),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: w* 0.06),
                    child: Column(
                      children: [
                        CustomTextInput(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          controller:emailController ,
                          label: 'Email',
                          prefixIcon:Icons.email,
                          width: 0.7, height: 0.1,
                           ),
                         SizedBox(height: h* 0.02,),
                        Consumer(
                            builder: (context,ref,child) {
                              final passwordVisibility = ref.watch(eyeBool);
                              return CustomTextInput(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  controller:passwordController ,
                                  maxLines: 1,
                                  label: 'Password',
                                  prefixIcon:
                              Icons.lock,width: 0.7,
                                  obscureText:passwordVisibility ,
                                  suffixIcon:ref.watch(eyeBool)==false?
                                  Icons.remove_red_eye_outlined:Icons.visibility_off,
                                  height: 0.12,
                                  onSuffixIconTap: (){
                                    if (kDebugMode) {
                                      print("sx");
                                    }
                                    ref.read(eyeBool.notifier)
                                        .state = !passwordVisibility;
                                    ref.watch(eyeBool)!;
                                    if (kDebugMode) {
                                      print(ref.watch(eyeBool));
                                    }}
                              );
                            }
                        ),
                        const SizedBox(height: 30,),
                        Consumer(
                            builder: (context,ref,child) {
                              return SizedBox(
                                width: w*0.7,
                                height: h*0.05,
                                child: RoundedLoadingButton(icon: false,
                                  backgroundColor:Palette.redLightColor,
                                  TextColor: Colors.white,
                                  text: 'Login',
                                  isLoading: false, onPressed: (){
                                if(_formKey.currentState!.validate()) {
                                       showDialog(context: context, builder: (context){
                                         return ConfirmationDialog(onConfirmed: (){
                                           if(emailController.text.trim().isNotEmpty
                                               &&passwordController.text.trim().isNotEmpty){
                                             login();
                                             Navigator.pop(context);
                                           }
                                           else{
                                             emailController.text.trim().isEmpty?
                                             showSnackBar(  text: ' "Enter Email"', color: true, context: context):
                                             showSnackBar( text: 'Enter Password', color: true, context: context) ;
                                           }
                                           if (kDebugMode) {
                                             print('Button pressed');
                                           }
                                         },
                                             onCancel: (){
                                               Navigator.pop(context);
                                             },
                                           message: 'Are you sure you want to Login?',);
                                       });
                                  }
                                },),
                              );
                            }
                        ),
                         SizedBox(height: h * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text("Don't Have an Account?",style: TextStyle(
                              color: Colors.black54,
                              fontSize: w * 0.04,
                            ),),
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpScreen()));
                            }, child:  Text("Sign Up",style: TextStyle(fontSize: w * 0.04,
                                color: Palette.redLightColor,fontWeight: FontWeight.w600),))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ) ,
        ),
      ),
    );
  }
}

