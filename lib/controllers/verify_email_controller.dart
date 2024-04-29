

import 'dart:async';

import 'package:furniture_user_side/consts/consts.dart';
import 'package:furniture_user_side/controllers/auth_controller.dart';
import 'package:furniture_user_side/views/auth_screen/success_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController{
  static VerifyEmailController get instance => Get.find();
  AuthController authController = AuthController();
  //send email whenever verify screen appears & Set timer for auto redirect
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    // TODO: implement onInit
    super.onInit();
  }


  sendEmailVerification() async {
    try {
      //AuthController authController = AuthController();
      await authController.sendEmailVerification();
      // Show a success message
      Get.snackbar(
        'Email Sent',
        'Please check your email for verification',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }catch (e) {
      print('Error sending email verification: $e');
      // Handle the error as needed
      Get.snackbar(
        'Error',
        'Error sending email verification: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        colorText: whiteColor,
        backgroundColor: redColor,
      );
    }
  }

  setTimerForAutoRedirect(){
    Timer.periodic(const Duration(seconds: 2), (timer) async{
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if(user?.emailVerified ?? false){
        timer.cancel();
        //timer = null;
        Get.off(()=>SuccessScreen(
          image: succesfullyregister,
          title: successemail,
          subTitle: confirmemail ,
          onPressed: () => authController.screenRedirect(),));
      }
    });
  }

  checkEmailVerificationStatus() async{
    final currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser != null && currentUser.emailVerified){
      Get.off(()=>SuccessScreen(
        image: succesfullyregister,
        title: successemail,
        subTitle: confirmemail ,
        onPressed: () => authController.screenRedirect(),));
    }
  }
}