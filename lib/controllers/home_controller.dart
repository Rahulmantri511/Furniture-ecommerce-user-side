import 'package:furniture_user_side/consts/consts.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    getUsername();
    super.onInit();
  }

  var currentNavIndex = 0.obs;



  var username = '';

  var searchController = TextEditingController();

  Future<void> getUsername() async {
    var n = await firestore.collection(usersCollection).where(
      'id',
      isEqualTo: currentUser!.uid,
    ).get().then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['name'] as String?;
      }
      return null; // Return null if no document is found
    });

    username = n ?? ''; // Use an empty string if the value is null
  }

}