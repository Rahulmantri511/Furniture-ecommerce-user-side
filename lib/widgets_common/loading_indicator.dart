import 'package:furniture_user_side/consts/colors.dart';
import 'package:flutter/material.dart';

Widget loadingIndicator(){
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(redColor),
  );
}