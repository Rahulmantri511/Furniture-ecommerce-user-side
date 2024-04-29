import 'package:furniture_user_side/controllers/auth_controller.dart';
import 'package:furniture_user_side/views/auth_screen/password_configuration/reset_password.dart';
import 'package:get/get.dart';

import '../consts/consts.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();
  AuthController authController = AuthController();

  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormkey = GlobalKey<FormState>();


  // send reset password email

  sendPasswordResetEmail() async {
    try {
      if (!forgetPasswordFormkey.currentState!.validate()) {
        return;
      }

      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false, // Prevent user from dismissing the loading dialog
      );

      // Simulate sending a password reset email (replace this with your actual logic)
      await authController.sendPasswordResetEmail(email.text);

      // Close loading indicator
      Get.back(); // Dismiss the loading indicator dialog

      // Show success message and navigate to ResetPassword screen
      Get.snackbar('Success', 'Password reset email sent successfully',
          snackPosition: SnackPosition.BOTTOM);
      Get.to(() => ResetPassword(email: email.text));
    } catch (e) {
      // Close loading indicator in case of an error
      Get.back();

      // Handle any errors during the process
      Get.snackbar('Error', 'Failed to send password reset email',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  resendPasswordResetEmail(String email) async{
    try {

      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false, // Prevent user from dismissing the loading dialog
      );

      // Simulate sending a password reset email (replace this with your actual logic)
      await authController.sendPasswordResetEmail(email);

      // Close loading indicator
      Get.back(); // Dismiss the loading indicator dialog

      // Show success message and navigate to ResetPassword screen
      Get.snackbar('Email Sent', 'Password reset email sent successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
    // Close loading indicator in case of an error
    Get.back();

    // Handle any errors during the process
    Get.snackbar('Error', 'Failed to send password reset email',
    snackPosition: SnackPosition.BOTTOM);
    }
  }

}