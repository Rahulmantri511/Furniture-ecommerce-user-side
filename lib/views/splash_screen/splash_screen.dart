import 'package:furniture_user_side/consts/consts.dart';
import 'package:furniture_user_side/views/auth_screen/login_screen.dart';
import 'package:furniture_user_side/views/home_screen/home.dart';
import 'package:furniture_user_side/widgets_common/applogo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 // creating a method to change screen

  changeScreen(){
    Future.delayed(const Duration(seconds:5),(){
      //using getX
      //Get.to(()=>const LoginScreen());

      auth.authStateChanges().listen((User? user) {
        if(user == null && mounted){
          Get.to(()=> const LoginScreen());
        }else{
          Get.to(()=> const Home());
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3E8E1),
      body: Center(
        child: Column(
          children: [
            Align(alignment:Alignment.topLeft , child: Image.asset(icSplashBg,width: 150,)),
            20.heightBox,
            applogoWidget(),

            Lottie.network('https://lottie.host/eec6dee7-0799-4fed-aa0a-604d2657079b/T6RPxMfDTN.json',height: 400),
            10.heightBox,
            appname.text.fontFamily(bold).size(22).color(redColor).make(),
            5.heightBox,
            appversion.text.white.make(),
            const Spacer(),
            //credits.text.white.fontFamily(semibold).make(),
            // our splash screen UI is completed...

          ],
        ),
      ),
    );
  }
}
