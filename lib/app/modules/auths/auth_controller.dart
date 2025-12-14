import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/services/auth_services.dart';
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/app/utils/messages.dart';
import 'package:live_video_apps/pages/home_page.dart';
import 'package:logger/web.dart';

Logger logger = Logger();

class AuthController extends GetxController {
  final AuthProvider authProvider = Get.find<AuthProvider>();
  final AuthServices authServices = AuthServices();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final _isLoading = false.obs;

  get isLoading => _isLoading.value;
  var phoneNumberController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();

  var isPhoneNumberValid = true.obs;
  var isPasswordValid = true.obs;
  var isNameValid = true.obs;

  void login() async {
    logger.i("LoginFormKey: ${loginFormKey}");
    try {
      logger.i("conecting..");
      _isLoading.value = true;
      if (loginFormKey.currentState!.validate()) {
        loginFormKey.currentState!.save();
        String phoneNumber = phoneNumberController.text.trim();
        String password = passwordController.text.trim();

        // Call the post Api method to send data
        var userInfo = await authServices.login(phoneNumber, password);
        logger.i("Response Auth Controller: ${userInfo}");

        phoneNumberController.clear();
        passwordController.clear();

        authProvider.user = userInfo;
        //authProvider.user.token;
        // Get.offAll(() => VentesScreen());
        Get.offAll(() => HomePage());
        goodMessage("Connexion avec succés");
      }
    } catch (e) {
      errorMessage("Impossible de se connecter");
      logger.w("Error: ${e}");
    } finally {
      _isLoading.value = false;
    }
  }

  void signup() async {
    String phoneNumber = phoneNumberController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    try {
      if (signupFormKey.currentState!.validate()) {
        //signupFormKey.currentState!.save();
        logger.i("Signin in signinFormKey : ${signupFormKey}");
        _isLoading.value = true;
        var userRegistred = authServices.signin(name, phoneNumber, password);
        authProvider.userRegister = await userRegistred;
        Get.offAll(() => LoginScreen());
        goodMessage("Succés: Inscription");
      }
    } catch (e) {
      errorMessage("Erreur");
    } finally {
      _isLoading.value = false;
    }
    //validating email and password and checking a static email just for checking

    //var response = remoteServices.signUp(name, phoneNumber, password);
  }

  Future<void> logout() async {
    Get.offAll(() => LoginScreen());
    authProvider.reset();
    // Rebind if need it
    goodMessage("Déconneté");
  }
}
