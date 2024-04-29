import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_user_side/consts/consts.dart';
import 'package:furniture_user_side/consts/lists.dart';
import 'package:furniture_user_side/controllers/auth_controller.dart';
import 'package:furniture_user_side/controllers/profile_controller.dart';
import 'package:furniture_user_side/services/firestore_services.dart';
import 'package:furniture_user_side/views/auth_screen/login_screen.dart';
import 'package:furniture_user_side/views/profile_screen/components/details_cart.dart';
import 'package:furniture_user_side/views/profile_screen/edit_profile_screen.dart';
import 'package:furniture_user_side/widgets_common/bg_widget.dart';
import 'package:get/get.dart';
import '../../widgets_common/loading_indicator.dart';
import '../chat_screen/messaging_screen.dart';
import '../order_screen/order_screen.dart';
import '../wishlist_screen/wishlist_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(ProfileController());
    Get.find<AuthController>().currentUserStream.listen((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // var controller = Get.put(ProfileController());

    return bgWidget(
      Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection(usersCollection).doc(currentUser!.email).snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot>snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('User data not found.'));
            }
              final data = snapshot.data!.data() as Map<String, dynamic>;

              return SafeArea(
                child: Column(
                  children: [
                    // edit profile button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.edit,
                          color: whiteColor,
                        ),
                      ).onTap(() {
                        controller.nameController.text = data['name'];
                        Get.to(() => EditProfileScreen(data: data));
                      }),
                    ),

                    // users detail section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          data['imageUrl'] == ''
                              ? Image
                              .asset(
                            imgProfile2,
                            width: 80,
                            fit: BoxFit.cover,
                          )
                              .box
                              .roundedFull
                              .clip(Clip.antiAlias)
                              .make()
                              : Image
                              .network(
                            data['imageUrl'],
                            width: 70,
                            fit: BoxFit.cover,
                          )
                              .box
                              .roundedFull
                              .size(80, 80)
                              .clip(Clip.antiAlias)
                              .make(),
                          10.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['name']}"
                                    .text
                                    .fontFamily(bold).size(16)
                                    .color(Colors.white)
                                    .make(),
                                "${data['email']}".text.white.fontFamily(semibold).make(),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: whiteColor,
                              ),
                            ),
                            onPressed: () async {
                              await Get.put(AuthController()).signoutMethod();
                              Get.find<ProfileController>().dispose();
                              Get.put(ProfileController());
                              Get.offAll(() => const LoginScreen());
                            },
                            child: logout.text
                                .fontFamily(semibold)
                                .white
                                .make(),
                          )
                        ],
                      ),
                    ),

                     10.heightBox,
                    FutureBuilder(
                      future: FirestoreServices.getCounts(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: loadingIndicator());
                        } else {
                          var CountData = snapshot.data;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              detailsCard(
                                count: CountData[0].toString(),
                                title: "in your cart",
                                width: context.screenWidth / 3.4,
                              ),
                              detailsCard(
                                count: CountData[1].toString(),
                                title: "in your wishlist",
                                width: context.screenWidth / 3.4,
                              ),
                              detailsCard(
                                count: CountData[2].toString(),
                                title: "your orders",
                                width: context.screenWidth / 3.4,
                              ),
                            ],
                          );
                        }
                      },
                    ),

                    // buttons section
                    ListView
                        .separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const Divider(color: lightGrey);
                      },
                      itemCount: profileButtonsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Get.to(() => const OrdersScreen());
                                break;
                              case 1:
                                Get.to(() => const WishlistScreen());
                                break;
                              case 2:
                                Get.to(() => const MessagesScreen());
                                break;
                            }
                          },
                          leading: Image.asset(
                            profileButtonsIcon[index],
                            width: 22,
                          ),
                          title: profileButtonsList[index]
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                        );
                      },
                    )
                        .box
                        .white
                        .rounded
                        .margin(const EdgeInsets.all(12))
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .shadowSm
                        .make()
                        .box
                       // .color(Color(0xff794C2D))
                        .make(),
                  ],
                ),
              );
          //   } else if (!snapshot.hasError) {
          //     return Center(child: Text('Error${snapshot.error.toString()}'));
          //   }
          //   return CircularProgressIndicator();
           },
        ),
      ),
    );
  }
}