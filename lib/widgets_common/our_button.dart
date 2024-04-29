import 'package:furniture_user_side/consts/consts.dart';

Widget ourButton({onPress, color, textColor,String? title }){
  return ElevatedButton(
      style:ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        ),
        backgroundColor: color,

        padding: const EdgeInsets.all(12),
      ),
      onPressed: onPress,
      child: title!.text.color(textColor).fontFamily(bold).make());
}