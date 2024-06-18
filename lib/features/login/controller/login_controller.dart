
import 'package:coffee_shop_management/features/login/screen/signup_screen.dart';
import 'package:coffee_shop_management/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/globals.dart';
import '../../../core/common/upload_message.dart';
import '../../Home/screens/navigation_screen.dart';
import '../repository/login_repository.dart';
import '../screen/login_screen.dart';

final loginControllerProvider = StateNotifierProvider<LoginController, bool>(
        (ref) => LoginController(
        loginRepository: ref.read(loginRepositoryProvider), ref: ref));
final userProvider = StateProvider<UserModel?>((ref) => null);
final getUserProvider=StreamProvider.family((ref,String uid){
  final loginController=ref.watch(loginControllerProvider.notifier);
  return loginController.getUser(uid);
} );


class LoginController extends StateNotifier<bool> {
  final LoginRepository _loginRepository;
  final Ref _ref;

  LoginController({
    required LoginRepository loginRepository,
    required Ref ref,
  })
      : _loginRepository = loginRepository,
        _ref = ref,
        super(false);

  // Future<void> login(String password, String email, BuildContext context) async {
  //   state = true;
  //
  //   final res = await _loginRepository.login(password, email);
  //   state = false;
  //
  //   if (!context.mounted) {
  //     // Print or log the issue, if the context is not mounted
  //     print("Context is not mounted, cannot navigate");
  //     return;
  //   }
  //
  //   res.fold(
  //         (l) {
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const LoginScreen(),
  //         ),
  //             (route) => false,
  //       );
  //       // Optionally show a snackbar or some feedback
  //       // showSnackBar(text: l.message, color: true, context: context);
  //     },
  //         (r) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const NavigationScreen(),
  //         ),
  //       );
  //       // Optionally show a snackbar or some feedback
  //       // showSnackBar(text: "Login Successfully", color: false, context: context);
  //     },
  //   );
  // }




  Future<void> login({required String email,
    required String password,
    required BuildContext context}) async {
    state = true;
    final res =
    await _loginRepository.login(password: password, email: email);
    state = false;
    res.fold(
            (l) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to edit order: ')),
            ),
            (r) async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order added successfully!')),
              );
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => const NavigationScreen()),
                (route) => false,
          );
    }
    );
  }


  Future<void> registerUser({
    required String username,
    required String email,
    required String phone,
    required String password,
    required BuildContext context,
  }) async {
    final res = await _loginRepository.registerUser(
      username: username,
      email: email,
      phone: phone,
      password: password,
    );

    res.fold(
          (l) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUpScreen(),
          ),
              (route) => false,
        );
      },
          (r) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>  const NavigationScreen(),
          ),
              (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('New User Created')),
        );
          }
    );
  }



  Future<void> checkKeepLogin(BuildContext context) async {
    final res = await _loginRepository.checkKeepLogin();
    res.fold(
          (l) {
            if(mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            }
      },
          (r) async {
        _ref.read(userProvider.notifier).update((state) => r);
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NavigationScreen()),
                (route) => false,
          );
        }
      },
    );
  }


  Future<void> logout(BuildContext context) async {
    await _loginRepository.logOutUser();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
            (route) => false,
      );
      prefs?.clear();
    }
  }
  Future passwordReset({required String email}) async {
    return _loginRepository.passwordReset(email: email);
  }

  Stream<UserModel?> getUser(String uid){
    return _loginRepository.getUser(uid);
  }


}