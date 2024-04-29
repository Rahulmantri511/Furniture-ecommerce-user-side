import 'package:furniture_user_side/controllers/auth_controller.dart';
import 'package:furniture_user_side/utils/validation/validation.dart';
import 'package:furniture_user_side/views/auth_screen/verify_email.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../consts/consts.dart';
import '../../widgets_common/applogo_widget.dart';
import '../../widgets_common/bg_widget.dart';
import '../../widgets_common/custom_textfield.dart';
import '../../widgets_common/our_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? ischeck = false;
  var controller = Get.put(AuthController());

  // text controller
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return bgWidget(
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogoWidget(),
                10.heightBox,
                "Join the $appname".text.fontFamily(bold).white.size(18).make(),
                15.heightBox,

                Obx(()=> Column(
                    children: [
                      customTextField(hint: nameHint,title: name,controller: nameController,isPass: false,validator: (value)=> TValidator.validateEmptyText(' name ', value)),
                      customTextField(hint: emailHint,title: email,controller: emailController,isPass: false,validator: (value)=> TValidator.validateEmail(value)),
                      customTextField(hint: passwordHint,title: password,controller: passwordController,isPass: controller.hidePassword.value,validator: (value)=> TValidator.validatePassword(value),
                          icon: IconButton(onPressed: ()=> controller.hidePassword.value = !controller.hidePassword.value,
                              icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash: Iconsax.eye ))),
                      customTextField(hint: passwordHint,title: retypePassword,controller: passwordRetypeController,isPass: true,validator: (value)=> TValidator.validatePassword(value),
                          // icon: IconButton(onPressed: ()=> controller.hidePassword.value = !controller.hidePassword.value,
                          //     icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash: Iconsax.eye))
                      ),
                      20.heightBox,
                      // Align(
                      //     alignment: Alignment.centerRight,
                      //     child: TextButton(onPressed: (){}, child: forgetPass.text.make())),

                      Row(
                        children: [
                          Checkbox(
                            activeColor: redColor,
                            checkColor: whiteColor,
                            value: ischeck,
                            onChanged: (newValue){
                              setState(() {
                                ischeck = newValue;
                              });
                            },
                          ),
                          5.widthBox,
                          Expanded(
                            child: RichText(
                                text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: "I agree to the ",
                                    style: TextStyle(
                                      fontSize: 13,
                                  fontFamily: regular,
                                  color: fontGrey,
                                )),
                                TextSpan(
                                    text: termAndCond,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: regular,
                                      color: redColor,
                                    )),
                                TextSpan(
                                    text: " & ",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: regular,
                                      color: fontGrey,
                                    )),
                                TextSpan(
                                    text: privacyPolicy,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: regular,
                                      color: redColor,
                                    )),
                              ],
                            )),
                          ),
                        ],
                      ),
                      5.heightBox,
                      controller.isloading.value?  const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      ): ourButton(color: ischeck == true ? redColor : lightGrey,
                          textColor: whiteColor,
                          title: signup ,
                        //   onPress: (){
                        // Get.to(()=>VerifyEmailScreen());
                        //   }
                          onPress: () async{
                              if(ischeck !=false){
                                String? nameError = TValidator.validateEmptyText('Name', nameController.text);
                                String? emailError = TValidator.validateEmail(emailController.text);
                                String? passwordError = TValidator.validatePassword(passwordController.text);
                                String? retypePasswordError = TValidator.validatePassword(passwordRetypeController.text);
                                if (nameError != null || emailError != null || passwordError != null || retypePasswordError != null){
                                  VxToast.show(context, msg: nameError ?? emailError ?? passwordError ?? retypePasswordError ?? '');
                                } else {
                                controller.isloading(true);
                                try{
                                  await controller.signupMethod(emailController.text, passwordController.text, context).then((value){
                                    return controller.storeUserData(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text
                                    );
                                  }).then((value){
                                    //VxToast.show(context, msg: loggedin);
                                    Get.to(()=>const VerifyEmailScreen());
                                  });
                                } catch (e){
                                  auth.signOut();
                                  VxToast.show(context, msg: e.toString());
                                  controller.isloading(false);
                                }
                              }
                          }
                              }
                          ).box.width(context.screenWidth-50).make(),
                      10.heightBox,
                      // wrapping into gesture detector of velocity X
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          alreadyHaveAccount.text.color(fontGrey).make(),
                          login.text.color(redColor).make().onTap(() {
                            Get.back();
                          }),
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
