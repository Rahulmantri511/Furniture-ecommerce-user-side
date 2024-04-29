import 'package:furniture_user_side/consts/consts.dart';
import 'package:furniture_user_side/controllers/home_controller.dart';
import 'package:furniture_user_side/views/cart_screen/cart_screen.dart';
import 'package:furniture_user_side/views/category_screen/category_screen.dart';
import 'package:furniture_user_side/views/home_screen/home_screen.dart';
import 'package:furniture_user_side/views/profile_screen/profile_screen.dart';
import 'package:furniture_user_side/views/wishlist_screen/wishlist_screen.dart';
import 'package:furniture_user_side/widgets_common/exit_dialog.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // init home controller
    var controller = Get.put(HomeController());

    var navbarItem = [
      const Icon(Icons.home, size: 26,color: whiteColor,),
      const Icon(Icons.category, size: 26,color: whiteColor),
      const Icon(Icons.favorite, size: 26,color: whiteColor),
      const Icon(Icons.shopping_cart, size: 26,color: whiteColor),
      const Icon(Icons.person, size: 26,color: whiteColor),
    ];

    var navBody = [
      const HomeScreen(),
      const CategoryScreen(),
      const WishlistScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => exitDialog(context),
        );
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(
                  () => Expanded(
                child: navBody.elementAt(controller.currentNavIndex.value),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(
              () => CurvedNavigationBar(
                height: 60,
            index: controller.currentNavIndex.value,
            backgroundColor: whiteColor,
            color: const Color(0xff794C2D),// Change this to your preferred color
            items: navbarItem,
            onTap: (value) {
              controller.currentNavIndex.value = value;
            },
          ),
        ),
      ),
    );
  }
}

    // var navbarItem = [
    //   BottomNavigationBarItem(
    //       icon: Image.asset(
    //         icHome,
    //         width: 26,
    //       ),
    //       label: home),
    //   BottomNavigationBarItem(
    //       icon: Image.asset(
    //         icCategories,
    //         width: 26,
    //       ),
    //       label: categories),
    //   BottomNavigationBarItem(
    //       icon: Icon(Icons.favorite,size: 26,),
    //       label: wishlist1),
    //
    //   BottomNavigationBarItem(
    //       icon: Image.asset(
    //         icCart,
    //         width: 26,
    //       ),
    //       label: cart),
    //   BottomNavigationBarItem(
    //       icon: Image.asset(
    //         icProfile,
    //         width: 26,
    //       ),
    //       label: account),
    // ];
    //
    // var navBody = [
    //   const HomeScreen(),
    //   const CategoryScreen(),
    //   const WishlistScreen(),
    //   const CartScreen(),
    //   const ProfileScreen()
    // ];
//     return WillPopScope(
//       onWillPop: () async{
//         showDialog(
//             barrierDismissible:false,
//             context: context,
//             builder: (context)=> exitDialog(context));
//         return false;
//       },
//       child: Scaffold(
//         body: Column(
//           children: [
//             Obx(
//               () => Expanded(
//                 child: navBody.elementAt(controller.currentNavIndex.value),
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: Obx(
//           () => BottomNavigationBar(
//             currentIndex: controller.currentNavIndex.value,
//             backgroundColor: whiteColor,
//             selectedItemColor: redColor,
//             selectedLabelStyle: TextStyle(fontFamily: semibold),
//             type: BottomNavigationBarType.fixed,
//             items: navbarItem,
//             onTap: (value) {
//               controller.currentNavIndex.value = value;
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
