import 'package:furniture_user_side/consts/consts.dart';
import 'package:furniture_user_side/consts/lists.dart';
import 'package:furniture_user_side/controllers/product_controller.dart';
import 'package:furniture_user_side/views/category_screen/categories_details.dart';
import 'package:furniture_user_side/widgets_common/bg_widget.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: redColor
    ));
    var controller = Get.put(ProductController());
    return bgWidget(
      Scaffold(
        appBar: AppBar(
          title: categories.text.fontFamily(bold).white.make(),
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: redColor.withOpacity(0.5)),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 8,crossAxisSpacing: 8,mainAxisExtent: 200),
              itemBuilder: (context,index){
                return Column(
                  children: [
                    Image.asset(categoriesImages[index],height: 130,width: 200,fit: BoxFit.cover,),
                    10.heightBox,
                    categoriesList[index].text.color(darkFontGrey).align(TextAlign.center).make(),
                  ],
                ).box.white.rounded.clip(Clip.antiAlias).outerShadowSm.make().onTap(() {
                  controller.getSubCategories(categoriesList[index]);
                  Get.to(()=>CategoryDetails(title: categoriesList[index],subcategories: controller.subcat.toList()));
                });
          }),
        ),
      )
    );
  }
}