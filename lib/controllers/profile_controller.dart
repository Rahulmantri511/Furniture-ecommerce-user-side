import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_user_side/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  var profileImgPath = ''.obs;

  var profileImageLink = '';

  var isloading = false.obs;

  //textfield
  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();


  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  void updateUserData(Map<String, dynamic> userData) {
    name.value = userData['name'];
    email.value = userData['email'];
    profileImgPath.value = '';
    // update other properties
  }

  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.email}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile({name, password, imgUrl}) async {
    try {
      isloading(true);
      var store = firestore.collection(usersCollection).doc(currentUser!.email);
      await store.set({'name': name, 'password': password, 'imageUrl': imgUrl},
          SetOptions(merge: true));
    } finally {
      isloading(false);
    }
  }
  changeAuthPassword({email,password,newpassword})async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error) {
      print(error.toString());
    });
  }
  void resetState() {
    nameController.text='';
    // Reset other state variables...

    // Dispose of text controllers or other resources if needed
    // For example:

  }


}
