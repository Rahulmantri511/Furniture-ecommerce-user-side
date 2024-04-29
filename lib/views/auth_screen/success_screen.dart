import 'package:lottie/lottie.dart';

import '../../consts/consts.dart';
import '../../widgets_common/our_button.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subTitle, required this.onPressed});

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Lottie.asset(image,width:  MediaQuery.of(context).size.width * 0.6,),
              32.heightBox,
              title.text.center.color(darkFontGrey).size(20).fontFamily(bold).make(),
              16.heightBox,
              subTitle.text.center.make(),
              32.heightBox,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ourButton(
                      textColor: whiteColor,
                      color: redColor,
                      title: "Continue",
                      onPress: onPressed,

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
