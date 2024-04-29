import 'package:furniture_user_side/controllers/auth_controller.dart';
import 'package:furniture_user_side/controllers/verify_email_controller.dart';
import 'package:furniture_user_side/widgets_common/our_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController();
    final controller = Get.put(VerifyEmailController());
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // actions: [
        //   IconButton(onPressed:()=> Get.offAll(LoginScreen()), icon: Icon(CupertinoIcons.clear))
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Image(
                image: const AssetImage("assets/images/animation/verifyemail.png"),
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              32.heightBox,
              verifyemail.text.center.color(darkFontGrey).size(20).fontFamily(bold).make(),
              16.heightBox,
              (userEmail ?? '').text.center.size(15).fontFamily(semibold).make(),
              16.heightBox,
              confirmemail.text.center.make(),
              32.heightBox,
              SizedBox(
                width: double.infinity,
                child: ourButton(
                  textColor: whiteColor,
                  color: redColor,
                  title: "Continue",
                  onPress: () async {
                    await controller.checkEmailVerificationStatus();

                    // Check if the email is verified before navigating to the home page
                    if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
                      Get.offAllNamed('/home'); // Replace with your home page route
                    } else {
                      // Show a message or handle the case where the email is not verified yet
                      Get.snackbar(
                        "Email Not Verified",
                        "Please verify your email before proceeding.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ),
              TextButton(
                onPressed: () => controller.sendEmailVerification(),
                child: "Resend Email".text.color(redColor).make(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
