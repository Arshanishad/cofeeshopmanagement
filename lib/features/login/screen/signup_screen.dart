import 'package:coffee_shop_management/core/widget/alertbox.dart';
import 'package:coffee_shop_management/features/login/controller/login_controller.dart';
import 'package:coffee_shop_management/features/login/screen/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../core/common/globals.dart';
import '../../../core/common/upload_message.dart';
import '../../../core/constants/constants.dart';
import '../../../core/pallete/theme.dart';
import '../../../core/widget/rounded_loading_button.dart';
import '../../../core/widget/text.dart';
import '../../../core/widget/textformfield.dart';


class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  final eyeBool=StateProvider((ref) => false);
  final passVisibleProvider=StateProvider((ref) => false);
  final _formKey = GlobalKey<FormState>();


void confirmBox(){
  if(_formKey.currentState!.validate()){
    showDialog(
        builder: (context) {
          return ConfirmationDialog(onConfirmed: ()  {
             ref.watch(loginControllerProvider.notifier).registerUser(
                 username: nameController.text.trim(),
                 email: emailController.text.trim(),
                 phone: phoneController.text.trim(),
                 password: passwordController.text.trim(),
                 context: context);
            showDialog(context: context, builder: (context){
              return const AlertDialog(title: Text("Confirmation"),
                content: Text("Do you want to Sign Up?"),actions: [
                  CustomTextWidget(text: "User Created Successfully ")
                ],);
            });
            nameController.clear();
            phoneController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
            emailController.clear();
          }, onCancel: (){Navigator.pop(context);},
            message: 'Do Yo Want Sign Up',);
        }, context: context
    );
  }
  else{
    _formKey.currentState!.validate()!?
    showSnackBar(text: 'Fill the Form', color: false, context: context):
    nameController.text.trim().isEmpty?showSnackBar( text: "Please Enter Name", color: false, context: context):"";
  }
}



  @override

  void dispose() {
  nameController.dispose();
  emailController.dispose();
  passwordController.dispose();
  confirmPasswordController.clear();
  phoneController.clear();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Material(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child:Center(
            child: Form(
              key:_formKey ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   SizedBox(height: h*0.05,),
                  Image.asset(Constants.loginImage),
                   SizedBox(height: h*0.04,),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: w*0.05),
                    child: Column(
                      children: [
                        CustomTextInput(
                          controller:nameController ,
                          label: 'Name',
                          prefixIcon:Icons.person,
                          width: 0.7,
                          height: 0.1,
                        ),
                         SizedBox(height: h*0.02,),
                        CustomTextInput(
                          controller:emailController ,
                          label: 'Email',
                          prefixIcon:Icons.email,
                          width: 0.7, height: 0.1,
                        ),
                         SizedBox(height: h*0.01,),
                        SizedBox(
                          width: w * 0.7,
                          height: h*0.1,
                          child: IntlPhoneField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              label: Text("Phone Number",style: TextStyle(
                                color: Colors.grey,fontSize: w * 0.03
                              ),),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(w * 0.008),
                                borderSide: const BorderSide(
                                  color: Colors.grey ??Colors.white,
                                ),
                              ),
                            ),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              if (kDebugMode) {
                                print(phone.completeNumber);
                              }
                            },
                          ),
                        ),
                         SizedBox(height: h*0.01,),
                        Consumer(
                            builder: (context,ref,child) {
                              final passwordVisibility = ref.watch(eyeBool);
                              return CustomTextInput(
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
                         SizedBox(height: h*0.01,),
                        Consumer(
                            builder: (context,ref,child) {
                              final passwordVisibility = ref.watch(passVisibleProvider);
                              return CustomTextInput(
                                  controller:confirmPasswordController ,
                                  maxLines: 1,
                                  label: ' Confirm Password',
                                  prefixIcon:
                                  Icons.lock,width: 0.7,
                                  obscureText:passwordVisibility ,
                                  suffixIcon:ref.watch(passVisibleProvider)==false?
                                  Icons.remove_red_eye_outlined:Icons.visibility_off,
                                  height: 0.12,
                                  onSuffixIconTap: (){
                                    if (kDebugMode) {
                                      print("sx");
                                    }
                                    ref.read(passVisibleProvider.notifier)
                                        .state = !passwordVisibility;
                                    ref.watch(passVisibleProvider)!;
                                    if (kDebugMode) {
                                      print(ref.watch(passVisibleProvider));
                                    }}
                              );
                            }
                        ),
                         SizedBox(height: h*0.002,),
                        Consumer(
                            builder: (context,ref,child) {
                              return SizedBox(
                                width: w*0.7,
                                height: h*0.05,
                                child: RoundedLoadingButton(icon: false,
                                  backgroundColor:Palette.redLightColor,
                                  TextColor: Colors.white,
                                  text: 'Sign Up',
                                  isLoading: false, onPressed: (){
                                    confirmBox();
                                    if (kDebugMode) {
                                      print('Button pressed');
                                    }
                                  },),
                              );
                            }
                        ),
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
