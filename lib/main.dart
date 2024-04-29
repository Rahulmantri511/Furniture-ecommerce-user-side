import 'package:furniture_user_side/controllers/auth_controller.dart';
import 'package:furniture_user_side/views/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'consts/consts.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyD_70eItmlikQELBMAABNZk67VYkeKURY4",
          appId: "1:461249743712:android:7527de953a149bde7dac05",
          messagingSenderId: "461249743712",
          projectId: "furniture-oko",
      storageBucket: "furniture-oko.appspot.com"
      )
    );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.brown.withOpacity(0.5)
  ));
  await Get.putAsync(() async => AuthController());
  // await FirebaseAppCheck.instance.activate();
  // await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // we are using getX so we have to change this material app into getmaterialapp
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          // to set app bar icons color
          iconTheme: IconThemeData(
            color: darkFontGrey
          ),
          // set elevation to 0
          elevation: 0.0,
          backgroundColor: Colors.transparent
        ),
        fontFamily: regular,
      ),
      home: const SplashScreen(),
    );
  }
}


