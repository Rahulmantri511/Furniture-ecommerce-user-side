import 'package:furniture_user_side/controllers/forget_password_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../consts/consts.dart';
import '../../../widgets_common/our_button.dart';
import '../login_screen.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key,required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: ()=>Get.back(), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children:[
            Image(image: const AssetImage("assets/images/animation/verifyemail.png"),width:  MediaQuery.of(context).size.width * 0.6,),
            16.heightBox,
              email.text.center.color(darkFontGrey).size(20).fontFamily(bold).make(),
            32.heightBox,
            "Password Reset Email Sent".text.center.color(darkFontGrey).size(20).fontFamily(semibold).make(),
            16.heightBox,
            resetemailsub.text.start.center.make(),
            32.heightBox,
            SizedBox(
              width: double.infinity,
              child: ourButton(
                  textColor: whiteColor,
                  color: redColor,
                  title: "Done",
                  onPress: (){
                    Get.offAll(()=>const LoginScreen());
                  }
              ),
            ),
              TextButton(
                onPressed: () => ForgetPasswordController().resendPasswordResetEmail(email),
                child: "Resend Email".text.color(redColor).make(),
              )

            ],
          ),
        ),
      ),
    );
  }
}
