import 'package:furniture_user_side/consts/consts.dart';
import 'package:furniture_user_side/controllers/auth_controller.dart';
import 'package:furniture_user_side/services/auth_service.dart';
import 'package:furniture_user_side/views/auth_screen/password_configuration/forgot_password.dart';
import 'package:furniture_user_side/views/auth_screen/signup_screen.dart';
import 'package:furniture_user_side/views/home_screen/home.dart';
import 'package:furniture_user_side/widgets_common/applogo_widget.dart';
import 'package:furniture_user_side/widgets_common/bg_widget.dart';
import 'package:furniture_user_side/widgets_common/custom_textfield.dart';
import 'package:furniture_user_side/widgets_common/our_button.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(AuthController());
    return bgWidget(
        Scaffold(
          resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,

            Obx(()=>Column(
                children: [
                  customTextField(hint: emailHint,title: email,isPass: false,controller: controller.emailController),
                  customTextField(hint: passwordHint,title: password,controller: controller.passwordController,isPass: controller.hidePassword.value,
                      icon: IconButton(onPressed: ()=> controller.hidePassword.value = !controller.hidePassword.value,
                          icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash: Iconsax.eye ))),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: (){Get.to(()=>const ForgotPassword());},
                          child: forgetPass.text.make())),
                  5.heightBox,
                  controller.isloading.value
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  )
                      :ourButton(color: redColor,textColor: whiteColor,title: login ,
                      onPress: () async{
                       // await Get.find<AuthController>().signoutMethod(context);

                        controller.isloading(true);
                        var loginResult = await controller.loginMethod(context : context);
                        if(loginResult != null){
                          VxToast.show(context, msg: loggedin);
                          Get.offAll(()=> const Home());
                        } else{

                        }
                        controller.isloading(false);
                        controller.emailController.clear();
                        controller.passwordController.clear();

                  }).box.width(context.screenWidth-50).make(),
                  5.heightBox,
                  createNewAccount.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButton(color: lightGolden,textColor: redColor,title: signup ,onPress: () {
                    Get.to(()=>const SignupScreen());
                  }).box.width(context.screenWidth-50).make(),
              
                  10.heightBox,
                  loginWith.text.color(fontGrey).make(),
                  5.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          try {
                            await AuthService().signInWithGoogle();
                            Get.to(()=> Home());
                            // Navigate to the next screen or perform any post-sign-in actions
                          } catch (e) {
                            print("Error signing in with Google: $e");
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: lightGrey,
                          radius: 25,
                          child: Image.asset("assets/icons/google_logo.png"),
                        ),
                      )
                    ],
                  )
                ],
              ).box.white.rounded.padding(const EdgeInsets.all(16)).width(context.screenWidth - 70).shadowSm.make(),

            )
          ],
        ),
      ),
    ));
  }
}
