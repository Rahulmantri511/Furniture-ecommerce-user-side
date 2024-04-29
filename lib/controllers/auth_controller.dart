

import 'package:furniture_user_side/views/auth_screen/verify_email.dart';
import 'package:furniture_user_side/views/home_screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_user_side/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../utils/validation/validation.dart';
import '../views/auth_screen/login_screen.dart';


class AuthController extends GetxController {


  // final HomeController controller = Get.put(HomeController());

  var hidePassword = true.obs;
  var isloading = false.obs;
  Stream<User?> get currentUserStream => auth.authStateChanges();

  //textcontrollers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //login method

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //signup method
  Future<UserCredential?> signupMethod(email, password, BuildContext context) async {
    // Validate email
    String? emailError = TValidator.validateEmail(email);
    if (emailError != null) {
      VxToast.show(context, msg: emailError);
      return null; // Stop sign-up process if email is invalid
    }

    // Validate password
    String? passwordError = TValidator.validatePassword(password);
    if (passwordError != null) {
      VxToast.show(context, msg: passwordError);
      return null;
    }
      UserCredential? userCredential;

    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //storing data method

  storeUserData({name, password, email}) async {
    DocumentReference store =
    firestore.collection(usersCollection).doc(email);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid,
      'cart_count': "00",
      'wishlist_count': "00",
      'order_count': "00",
    });
  }

  // //signout method
  // Future<void> signoutMethod() async{
  //   try{
  //     await FirebaseAuth.instance.signOut();
  //     // Get.delete<AuthController>();
  //     Get.offAll(const LoginScreen());
  //   } catch (e){
  //
  //   }
  // }

  signoutMethod() async {
    try {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      await FirebaseAuth.instance.signOut();
      emailController.text = '';
      passwordController.text = '';
      isloading.value = false;

      // Navigate to login screen or wherever needed
      Get.offAll(() => const LoginScreen());
      // Other code...
    } catch (e) {
      // Handle errors...
    }
  }

  // email verification
  Future<void> sendEmailVerification() async{
    try{
      await auth.currentUser?.sendEmailVerification();
    }on FirebaseAuthException catch (e) {
     throw FirebaseAuthException(code: e.code,message: e.message);
    } catch (e){
      throw 'Something went wrong, try again';
    }
  }

  // forgot password
  Future<void> sendPasswordResetEmail(String email) async{
    try{
      await auth.sendPasswordResetEmail(email: email);
    }on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code,message: e.message);
    } catch (e){
      throw 'Something went wrong, try again';
    }
  }
  
  screenRedirect() async{
    final user = auth.currentUser;
    if(user != null){
      if(user.emailVerified){
        Get.offAll(()=> const Home());
      } else{
        Get.offAll(()=> const VerifyEmailScreen());
      }
    }else{
      Get.offAll(()=>const LoginScreen());
    }
  }

}