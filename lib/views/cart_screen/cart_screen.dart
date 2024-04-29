import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_user_side/consts/consts.dart';
import 'package:furniture_user_side/controllers/cart_controller.dart';
import 'package:furniture_user_side/services/firestore_services.dart';
import 'package:furniture_user_side/views/cart_screen/shipping_screen.dart';
import 'package:furniture_user_side/widgets_common/loading_indicator.dart';
import 'package:furniture_user_side/widgets_common/our_button.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: context.screenWidth - 60,
          height: 60,
          child: ourButton(
            color: redColor,
            onPress: () {
              if (controller.totalP.value > 0) {
                Get.to(() => const ShippingDetails());
              } else {
                // Show a toast message indicating that the cart is empty
                Get.snackbar(
                  "Cart is Empty",
                  "Please add items to your cart first.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: lightGrey,
                  colorText: Colors.black,
                );
              }
            },
            textColor: whiteColor,
            title: "Proceed to shipping",
          ),
        ),
      ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: redColor.withOpacity(0.5)),
        automaticallyImplyLeading: false,
        title: "Shopping cart"
            .text
            .color(darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Column(
              children: [
                200.heightBox,
                Center(
                  child: Image.asset(
                    'assets/images/animation/addtocart.gif', // Replace 'assets/empty_cart.gif' with the path to your GIF file
                    width: 250,
                    height: 250,
                  ),
                ),
                "Let's add some items ".text.make()
              ],
            );
          } else {
            var data = snapshot.data!.docs;
            controller.calculate(data);
            controller.productSnapshot = data;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: Image.network(
                                  '${data[index]['img']}',
                                  fit: BoxFit.cover,
                                ),
                              ).box
                                  .roundedFull
                                  .padding(const EdgeInsets.all(8))
                                  .clip(Clip.antiAlias)
                                  .make(),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    10.heightBox,
                                    "${data[index]['title']}"
                                        .text
                                        .fontFamily(semibold)
                                        .size(16)
                                        .make(),
                                    5.heightBox,
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // Decrease quantity
                                            controller.decreaseQuantity(index);
                                          },
                                          child: const Icon(
                                            Icons.remove,
                                            color: redColor,
                                            size: 20,
                                          ),
                                        ),
                                        5.widthBox,
                                        "${data[index]['qty']}"
                                            .text
                                            .fontFamily(semibold)
                                            .size(16)
                                            .make(),
                                        5.widthBox,
                                        InkWell(
                                          onTap: () {
                                            // Increase quantity
                                            controller.increaseQuantity(index);
                                          },
                                          child: const Icon(
                                            Icons.add,
                                            color: redColor,
                                            size: 20,
                                          ),
                                        ),
                                        150.widthBox,
                                        GestureDetector(
                                          onTap: () {
                                            FirestoreServices.deleteDociment(data[index].id);
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: redColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    "${data[index]['tprice'] * data[index]['qty']}"
                                        .numCurrency
                                        .text
                                        .size(14)
                                        .color(redColor)
                                        .fontFamily(semibold)
                                        .make(),

                                  ],
                                ),
                              ),

                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Total price"
                          .text
                          .fontFamily(semibold)
                          .color(darkFontGrey)
                          .make(),
                      Obx(
                            () => "${controller.totalP.value}"
                            .numCurrency
                            .text
                            .fontFamily(semibold)
                            .color(redColor)
                            .make(),
                      ),
                    ],
                  )
                      .box
                      .padding(const EdgeInsets.all(12))
                      .color(lightGolden)
                      .width(context.screenWidth - 60)
                      .roundedSM
                      .make(),
                  5.heightBox,
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
