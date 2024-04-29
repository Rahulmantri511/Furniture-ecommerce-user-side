import 'package:furniture_user_side/utils/validation/validation.dart';
import 'package:get/get.dart';

import '../../../consts/consts.dart';
import '../../../controllers/forget_password_controller.dart';
import '../../../widgets_common/our_button.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            forgetPass.text.size(20).fontFamily(bold).make(),
            16.heightBox,
            forgetPasssub.text.make(),
            20.heightBox,
            Form(
              key: controller.forgetPasswordFormkey,
              child: TextFormField(
                controller: controller.email,
                validator: TValidator.validateEmail,
                decoration: InputDecoration(
                  label: "E-mail".text.fontFamily(bold).make(),
                  prefixIcon: const Icon(Icons.arrow_right_alt_rounded),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: redColor))
                ),
              ),
            ),
            20.heightBox,
            SizedBox(
              width: double.infinity,
              child: ourButton(
                  textColor: whiteColor,
                  color: redColor,
                  title: "Continue",
                  onPress: ()=>controller.sendPasswordResetEmail()

              ),
            )
          ],
        ),
      ),
    );
  }
}
