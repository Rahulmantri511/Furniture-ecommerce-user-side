import 'package:furniture_user_side/consts/consts.dart';
import 'package:furniture_user_side/consts/lists.dart';
import 'package:furniture_user_side/views/category_screen/category_screen.dart';
import 'package:furniture_user_side/views/home_screen/components/featured_button.dart';
import 'package:furniture_user_side/views/home_screen/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/product_controller.dart';
import '../../services/firestore_services.dart';
import '../category_screen/item_details.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    final ProductController  productController = Get.put(ProductController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(12),
        color: lightGrey,
        width: context.screenWidth,
        height: context.screenHeight,
        child: SafeArea(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  color: lightGrey,
                  child: TextFormField(
                    controller: controller.searchController,
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        Get.to(() => SearchScreen(
                          title: value,
                        ));
                      }
                    },
                    decoration:  InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: const Icon(Icons.search).onTap(() {
                          if(controller.searchController.text.isNotEmptyAndNotNull){
                            Get.to(()=> SearchScreen(
                                title: controller.searchController.text
                            ));
                          }
      
                        }),
                        filled: true,
                        fillColor: whiteColor,
                        hintText: searchanything,
                        hintStyle: const TextStyle(color: textfieldGrey)
                    ),
                  ).box.outerShadow.make(),
                ),
                10.heightBox,
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        //swipers brands
                        // VxSwiper.builder(
                        //     aspectRatio: 16/9,
                        //     autoPlay: true,
                        //     height: 150,
                        //     enlargeCenterPage: true,
                        //     itemCount: slidersList.length,
                        //     itemBuilder: (context,index){
                        //       return Image.asset(
                        //           slidersList[index],
                        //           fit: BoxFit.fill
                        //       ).box.rounded.clip(Clip.antiAlias).margin(EdgeInsets.symmetric(horizontal: 8)).make();
                        //     }),
                        10.heightBox,
                        //deals buttons
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children:
                        //   List.generate(2, (index) => homeButtons(
                        //     height: context.screenHeight * 0.15,
                        //     width: context.screenWidth / 2.5,
                        //     icon: index == 0 ? icTodaysDeal : icFlashDeal,
                        //     title: index == 0 ? todayDeal : flashsale,
                        //   )),
                        // ),
                        // 2nd swiper
                        10.heightBox,
                      Image.asset(
                        secondSlidersList.isNotEmpty ? secondSlidersList.first : 'assets/images/sliderimg1.webp',
                        width: double.infinity,
                        height: 150, // Set your desired height
                        fit: BoxFit.cover,
                      ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 8)).make().onTap(() {Get.to(()=>const CategoryScreen()); }),
      
                        10.heightBox,
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: List.generate(3, (index) => homeButtons(
                        //     height: context.screenHeight * 0.15,
                        //     width: context.screenWidth / 3.5,
                        //     icon: index == 0? icTopCategories : index == 1 ? icBrands : icTopSeller,
                        //     title: index == 0? topCategories : index == 1 ? brand : topSellers,
                        //   )),
                        // ),
      
                        //featured categories
                        20.heightBox,
      
                        Align(
                            alignment: Alignment.centerLeft,
                            child: featuredCategories.text.color(redColor).size(18).fontFamily(bold).make()),
                        20.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(3, (index) => Column(
                              children: [
                                featuredButton(icon: featuredImages1[index],title: featuredTitles1[index]),
                                10.heightBox,
                                featuredButton(icon: featuredImages2[index],title: featuredTitles2[index]),
                              ],
                            ),
                            ).toList(),
                          ),
                        ),
      
                        // featured product
      
                        20.heightBox,
                        Container(
                          padding: const EdgeInsets.all(12),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              featuredProduct.text.color(redColor).fontFamily(bold).size(18).make(),
                              10.heightBox,
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: FutureBuilder(
                                  future: FirestoreServices.getFeaturedProducts(),
                                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      // Display shimmer loading animation while fetching data
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        enabled: true,
                                        child: Row(
                                          children: List.generate(
                                            3,
                                                (index) => Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 130,
                                                  height: 130,
                                                  color: Colors.white,
                                                ),
                                                10.heightBox,
                                                Container(
                                                  width: 100,
                                                  height: 16,
                                                  color: Colors.white,
                                                ),
                                                10.heightBox,
                                                Container(
                                                  width: 80,
                                                  height: 16,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.data!.docs.isEmpty) {
                                      return "No featured products".text.white.makeCentered();
                                    } else {
                                      var featuredData = snapshot.data!.docs;
                                      return Row(
                                        children: List.generate(
                                          featuredData.length,
                                              (index) => Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Image.network(
                                                featuredData[index]['p_imgs'][0],
                                                height: 130,
                                                width: 130,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else if (loadingProgress.expectedTotalBytes != null) {
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        color: redColor,
                                                        value: loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!,
                                                      ),
                                                    );
                                                  } else {
                                                    return const Center(
                                                      child: Text(
                                                        'Check your network',
                                                        style: TextStyle(color: redColor),
                                                      ),
                                                    );
                                                  }
                                                },
                                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                  return const Center(
                                                    child: Text(
                                                      'Check your network',
                                                      style: TextStyle(color: redColor),
                                                    ),
                                                  );
                                                },
                                              ),
                                              10.heightBox,
                                              "${featuredData[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                              10.heightBox,
                                              Row(
                                                children: [
                                                  const Text(
                                                    "₹ ",
                                                    style: TextStyle(color: redColor, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${featuredData[index]['p_price']}".numCurrency,
                                                    style: const TextStyle(color: redColor, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              )
      
                                            ],
                                          ).box.white
                                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                                              .roundedSM
                                              .padding(const EdgeInsets.all(8))
                                              .make().onTap(() {
                                            Get.to(() => ItemDetails(
                                              title: "${featuredData[index]['p_name']}",
                                              data: featuredData[index],
                                            ));
                                          }),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
      
      
                        //third  swipper
                        20.heightBox,
                      Image.asset(
                        // secondSlidersList.isNotEmpty ? secondSlidersList.first :
                        'assets/images/banner2.webp',
                        width: double.infinity,
                        height: 200, // Set your desired height
                        fit: BoxFit.fill,
                      ).box.rounded.clip(Clip.antiAlias).make().onTap(() {Get.to(()=>const CategoryScreen()); }),
                        // recently viewed section
      
      
      
                        // all products section
                        20.heightBox,
                        StreamBuilder(
                          stream: FirestoreServices.allProducts(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              // Display shimmer loading animation while fetching data
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                enabled: true,
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 6, // Set a placeholder count for the shimmer effect
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    mainAxisExtent: 300,
                                  ),
                                  itemBuilder: (context, index) {
                                    // Placeholder widget for shimmer effect
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 200,
                                          color: Colors.white,
                                        ),
                                        5.heightBox,
                                        Container(
                                          width: 150,
                                          height: 16,
                                          color: Colors.white,
                                        ),
                                        5.heightBox,
                                        Container(
                                          width: 100,
                                          height: 16,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )
                                        .box
                                        .make()
                                        .onTap(() {}); // Dummy onTap function for placeholder
                                  },
                                ),
                              );
                            } else {
                              var allProductsData = snapshot.data!.docs;
                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: allProductsData.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  mainAxisExtent: 300,
                                ),
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        allProductsData[index]['p_imgs'][0],
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else if (loadingProgress.expectedTotalBytes != null) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: redColor,
                                                value: loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!,
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                              child: Text(
                                                'Check your network',
                                                style: TextStyle(color: redColor),
                                              ),
                                            );
                                          }
                                        },
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return const Center(
                                            child: Text(
                                              'Check your network',
                                              style: TextStyle(color: redColor),
                                            ),
                                          );
                                        },
                                      ).box.border(width: 1,color: redColor).shadowSm.make(),
                                      5.heightBox,
                                      "${allProductsData[index]['p_name']}"
                                          .text
                                          .fontFamily(semibold)
                                          .color(darkFontGrey)
                                          .make(),
                                      5.heightBox,
                                      Row(
                                        children: [
                                          const Text(
                                            "₹ ",
                                            style: TextStyle(color: redColor, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${allProductsData[index]['p_price']}".numCurrency,
                                            style: const TextStyle(color: redColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
      
                                    ],
                                  )
                                      .box
                                      .make()
                                      .onTap(() {
                                    Get.to(() => ItemDetails(
                                      title: "${allProductsData[index]['p_name']}",
                                      data: allProductsData[index],
                                    ));
                                  });
                                },
                              );
                            }
                          },
                        )
      
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
