import 'package:furniture_user_side/consts/consts.dart';
import 'package:get/get.dart';

import '../../../controllers/product_controller.dart';
import '../../category_screen/categories_details.dart';

var controller = Get.find<ProductController>();
Widget featuredButton({
  String? title,
  icon,
}) {
  return Column(
    children: [
      Image.asset(
        icon,
        width: 160,
        fit: BoxFit.fill,
      ),
      10.widthBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make(),
    ],
  )
      .box
      .width(120)
      .margin(const EdgeInsets.symmetric(horizontal: 4))
      .white
      .padding(const EdgeInsets.all(4))
      .roundedSM
      .outerShadowSm
      .make()
      .onTap(() {
    Get.to(()=>CategoryDetails(title: title, subcategories: controller.subcat.toList()));
  });
}
