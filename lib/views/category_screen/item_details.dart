import 'package:furniture_user_side/consts/consts.dart';
import 'package:furniture_user_side/consts/lists.dart';
import 'package:furniture_user_side/controllers/product_controller.dart';
import 'package:furniture_user_side/views/cart_screen/cart_screen.dart';
import 'package:furniture_user_side/views/category_screen/categories_details.dart';
import 'package:furniture_user_side/views/chat_screen/chat_screen.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';

import '../../services/firestore_services.dart';
import '../../widgets_common/loading_indicator.dart';

class ItemDetails extends StatefulWidget {
  final String? title;
  final dynamic data;

  const ItemDetails({super.key, required this.title, this.data});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;
  void shareProductDetails(String title, String imageUrl, String price) {
    String shareText = 'Check out this amazing product!\n'
        'Name: $title\n'
        'Image: $imageUrl\n'
        'Price: $price';

    Share.share(shareText);
  }

  double userRating = 0;
  String userReview = '';

  void submitRatingAndReview() {
    // Submit userRating and userReview to Firebase
    // For simplicity, I assume there's a collection named 'product_reviews' in Firestore
    // and each review document contains fields 'rating', 'review', and 'product_id'
    FirebaseFirestore.instance.collection('product_reviews').add({
      'rating': userRating,
      'review': userReview,
      'product_id': widget.data['p_name'], // Assuming you have a field 'id' in your product data
      // You may need to adjust this based on your database structure
    });
    // Optionally, you can display a message to the user indicating the review submission was successful
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review submitted successfully')));
    setState(() {
      userRating = 0;
      userReview = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValues();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: widget.title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(
              onPressed: () {
                shareProductDetails(widget.title!, widget.data['p_imgs'][0], widget.data['p_price']);
              },
              icon: const Icon(Icons.share),
            ),
            Obx(() => IconButton(
              onPressed: () {
                if (controller.isFav.value) {
                  controller.removeFromWishlist(widget.data.id, context);
                } else {
                  controller.addToWishlist(widget.data.id, context);
                }
              },
              icon: Icon(
                Icons.favorite_outlined,
                color: controller.isFav.value ? redColor : darkFontGrey,
              ),
            )),
            IconButton(
              onPressed: () {
                Get.to(() => const CartScreen());
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Swiper section
                VxSwiper.builder(
                  autoPlay: true,
                  height: 350,
                  itemCount: widget.data['p_imgs'].length,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                  itemBuilder: (context, index) {
                    return Arc(
                      edge: Edge.BOTTOM,
                      arcType: ArcType.CONVEX,
                      height: 30,
                      child: Image.network(
                        widget.data['p_imgs'][index],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                10.heightBox,
                // Title and details section
                widget.title!.text.size(20).color(darkFontGrey).fontFamily(semibold).make(),
                10.heightBox,
                // Rating
                VxRating(
                  isSelectable: false,
                  value: double.parse(widget.data['p_rating']),
                  onRatingUpdate: (value) {},
                  normalColor: textfieldGrey,
                  selectionColor: redColor,
                  count: 5,
                  maxRating: 5,
                  size: 25,
                ),
                10.heightBox,
                Row(
                  children: [
                    const Text(
                      "₹ ",
                      style: TextStyle(color: redColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${widget.data['p_price']}".numCurrency,
                      style: const TextStyle(color: redColor, fontWeight: FontWeight.bold,fontSize: 16),
                    ),
                  ],
                ),

                10.heightBox,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "${widget.data['p_seller']}".text.white.fontFamily(semibold).make(),
                          5.heightBox,
                          "In House Brands".text.fontFamily(semibold).color(darkFontGrey).size(16).make(),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.message_rounded, color: darkFontGrey),
                    ).onTap(() {
                      Get.to(() => const ChatScreen(), arguments: [widget.data['p_seller'], widget.data['vendor_id']]);
                    }),
                  ],
                ).box.height(60).padding(const EdgeInsets.symmetric(horizontal: 16)).color(textfieldGrey).make(),
                20.heightBox,
                Obx(
                      () => Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: "Color: ".text.color(textfieldGrey).make(),
                          ),
                          Row(
                            children: List.generate(
                              widget.data['p_colors'].length,
                                  (index) => Stack(
                                alignment: Alignment.center,
                                children: [
                                  VxBox()
                                      .size(40, 40)
                                      .roundedFull
                                      .color(Color(widget.data['p_colors'][index]).withOpacity(1.0))
                                      .margin(const EdgeInsets.symmetric(horizontal: 4))
                                      .make()
                                      .onTap(() {
                                    controller.changeColorIndex(index);
                                  }),
                                  Visibility(
                                    visible: index == controller.colorIndex.value,
                                    child: const Icon(Icons.done, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ).box.padding(const EdgeInsets.all(8)).make(),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: "Quantity: ".text.color(textfieldGrey).make(),
                          ),
                          Obx(
                                () => Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.decreaseQuantity();
                                    controller.calculateTotalPrice(int.parse(widget.data['p_price']));
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                controller.quantity.value.text.size(16).color(darkFontGrey).fontFamily(bold).make(),
                                IconButton(
                                  onPressed: () {
                                    controller.increaseQuantity(int.parse(widget.data['p_quantity']));
                                    controller.calculateTotalPrice(int.parse(widget.data['p_price']));
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                10.widthBox,
                                "(${widget.data['p_quantity']} available)".text.color(textfieldGrey).make(),
                              ],
                            ),
                          ),
                        ],
                      ).box.padding(const EdgeInsets.all(8)).make(),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: "Total: ".text.color(textfieldGrey).make(),
                          ),
                          "${controller.totalPrice.value}".numCurrency.text.color(redColor).size(16).fontFamily(bold).make(),
                        ],
                      ).box.padding(const EdgeInsets.all(8)).make(),
                    ],
                  ),
                ).box.white.shadowSm.make(),
                10.heightBox,
                // Description section
                "Description".text.color(darkFontGrey).fontFamily(semibold).make(),
                10.heightBox,
                "${widget.data['p_description']} ".text.color(darkFontGrey).make(),

                // Button section
                10.heightBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: itemDetailButtonList.map((title) {
                    String content = '';

                    // Set content based on the title or specific logic
                    if (title == 'Specification') {
                      // Access specifications from widget.data or other data structure
                      content = widget.data['p_specification'] ?? '';
                    } else if (title == 'Seller Policy') {
                      // Access seller policy from widget.data or other data structure
                      content = widget.data['p_seller_policy'] ?? '';
                    } else if (title == 'Return Policy') {
                      // Access return policy from widget.data or other data structure
                      content = widget.data['p_return_policy'] ?? '';
                    } else if (title == 'Warranty') {
                      // Access warranty details from widget.data or other data structure
                      content = widget.data['p_warranty'] ?? '';
                    }

                    return ExpandableTile(
                      title: title,
                      content: content,
                    );
                  }).toList(),
                ),
                // Review and rating section
                10.heightBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reviews section
                    "Reviews and Ratings".text.color(darkFontGrey).fontFamily(semibold).make(),
                    10.heightBox,
                    // VxRating widget for users to rate the product
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Rating: ',
                            style: TextStyle(
                              fontFamily: semibold,
                              color: darkFontGrey,
                              fontSize: 16,
                            ),
                          ),
                          CustomRating(
                            initialRating: userRating,
                            onRatingUpdate: (value) {
                              setState(() {
                                userRating = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    10.heightBox,
                      // Input field for users to write their reviews
                    TextFormField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Write your review...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Border color when not focused
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: redColor, // Border color when focused
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          userReview = value;
                        });
                      },
                    ),

                    10.heightBox,
                    ElevatedButton(
                      onPressed: () {
                        // Call method to submit rating and review
                        submitRatingAndReview();
                        // Optionally, you can reset userRating and userReview after submission

                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(redColor),
                      ),
                      child: 'Submit Review'.text.white.make(),
                    ),
                  ],
                ),

                // Products you may also like section
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      productsyoumaylike.text.color(redColor).fontFamily(bold).size(18).make(),
                      10.heightBox,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FutureBuilder(
                          future: FirestoreServices.getProductsYouLike(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: loadingIndicator(),
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
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ).box.shadowSm.border(width: 1,color: redColor).make(),
                                      10.heightBox,
                                      "${featuredData[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                      10.heightBox,
                                      "${featuredData[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).make(),
                                    ],
                                  ).box.white
                                      .margin(const EdgeInsets.symmetric(horizontal: 4))
                                      .roundedSM
                                      .padding(const EdgeInsets.all(8))
                                      .make()
                                      .onTap(() {
                                    Get.to(() => CategoryDetails(title: "${featuredData[index]['p_category']}", subcategories: controller.subcat.toList(),));
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          height: 60,
          child: AddToCartButton(
            trolley: const Icon(Icons.shopping_cart, color: Colors.white),
            text: "Add to cart".text.white.size(14).maxLines(1).overflow(TextOverflow.fade).make(),
            check: const SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 24,
              ),
            ),
            backgroundColor: redColor,
            onPressed: (id) async {
              if (controller.quantity.value > 0) {
                if (id == AddToCartButtonStateId.idle) {
                  setState(() {
                    stateId = AddToCartButtonStateId.loading;
                  });

                  controller.addToCart(
                    color: widget.data['p_colors'][controller.colorIndex.value],
                    context: context,
                    vendorID: widget.data['vendor_id'],
                    img: widget.data['p_imgs'][0],
                    qty: controller.quantity.value,
                    sellername: widget.data['p_seller'],
                    title: widget.data['p_name'],
                    tprice: controller.totalPrice.value,
                  );

                  VxToast.show(context, msg: "Added to cart");

                  await Future.delayed(const Duration(seconds: 2));

                  setState(() {
                    stateId = AddToCartButtonStateId.done;
                  });

                  await Future.delayed(const Duration(seconds: 2));

                  setState(() {
                    stateId = AddToCartButtonStateId.idle;
                  });

                  controller.resetQuantity();
                }
              } else {
                VxToast.show(context, msg: "Minimum 1 product is required");
              }
            },
            stateId: stateId,
          ),
        ),
      ),
    );
  }
}
class ExpandableTile extends StatefulWidget {
  final String title;
  final String content;

  const ExpandableTile({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  _ExpandableTileState createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: semibold,
                  color: darkFontGrey,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _isExpanded ? Icons.arrow_drop_down : Icons.arrow_forward,
                color: darkFontGrey,
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded)
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.content,
              style: const TextStyle(color: Colors.black),
            ),
          ),
      ],
    );
  }
}
class CustomRating extends StatefulWidget {
  final double initialRating;
  final Function(double) onRatingUpdate;

  const CustomRating({
    super.key,
    required this.initialRating,
    required this.onRatingUpdate,
  });

  @override
  _CustomRatingState createState() => _CustomRatingState();
}

class _CustomRatingState extends State<CustomRating> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData iconData;
        Color color;

        if (_rating >= index + 1) {
          iconData = Icons.star;
          color = Colors.orange;
        } else if (_rating >= index + 0.5) {
          iconData = Icons.star_half;
          color = Colors.orange;
        } else {
          iconData = Icons.star_border;
          color = Colors.grey;
        }

        return GestureDetector(
          onTap: () {
            double newRating = index + 1;
            if (_rating == newRating) {
              newRating -= 0.5;
            }
            widget.onRatingUpdate(newRating);
            setState(() {
              _rating = newRating;
            });
          },
          child: Icon(
            iconData,
            color: color,
          ),
        );
      }),
    );
  }
}
