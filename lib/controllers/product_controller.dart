import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_user_side/consts/consts.dart';
import 'package:furniture_user_side/models/category_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductController extends GetxController{

  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;
  var searchController = TextEditingController();

  RxList<String> subcat = <String>[].obs;
  var selectedSubcategories = <String>[];
  String? selectedCategory;

  var isFav = false.obs;
  var appliedFilters = <String>[];
  var filterScreenSelectedFilters = <String>[].obs;
  var filterScreenSelectedMinPrice = 0.0.obs;
  var filterScreenSelectedMaxPrice = 50000.0.obs;
  RxList<String> filterScreenSelectedColors = <String>[].obs;
  RxList<String> filterScreenSelectedMaterials = <String>[].obs;

  Future<void> fetchCategoryFilters(String category) async {
    try {
      // Fetch products for the given category from Firebase
      var querySnapshot = await FirebaseFirestore.instance.collection('products').where('category', isEqualTo: category).get();

      // Initialize sets to store unique colors and materials
      var colors = <String>{};
      var materials = <String>{};

      // Iterate through each product document to collect color and material information
      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        // Collect color and material information from the current product document
        colors.addAll(data['colors']?.cast<String>() ?? []);
        materials.addAll(data['materials']?.cast<String>() ?? []);
      }

      // Update the filter variables with the collected colors and materials
      filterScreenSelectedColors = colors.toList().obs;
      filterScreenSelectedMaterials = materials.toList().obs;

      // Update the UI
      update();
    } catch (e) {
      print('Error fetching filters for category $category: $e');
    }
  }






  void applyFiltersForCategory(String category) {
    // Clear previous filters before applying new ones
    appliedFilters.removeWhere((filter) => filter.startsWith('$category:'));
    // Add the filters from the FilterScreen with category prefix
    appliedFilters.addAll(filterScreenSelectedFilters.map((filter) => '$category:$filter'));
  }

  // Method to reset filters for a specific category
  void resetFiltersForCategory(String category) {
    appliedFilters.removeWhere((filter) => filter.startsWith('$category:'));
    // Reset other filters as needed
    update(); // Update the UI when filters are reset
  }

  // Method to apply filters
  void applyFilters() {
    appliedFilters = List.from(selectedSubcategories);
    // Add more filters as needed

    // Add price filters
    if (filterScreenSelectedMinPrice.value > 0 || filterScreenSelectedMaxPrice.value < 50000) {
      appliedFilters.add('${filterScreenSelectedMinPrice.value}-${filterScreenSelectedMaxPrice.value}');
    }

    update(); // Update the UI when filters are applied
  }
  // Method to reset filters
  void resetFilters() {
    selectedSubcategories.clear();
    appliedFilters.clear();
    // Reset other filters as needed
    update(); // Update the UI when filters are reset
  }

  // Method to check if a product passes the applied filters
  bool doesProductPassFilters(data, String currentCategory) {
    // Check if the product belongs to the current category
    if (data['p_category'] != currentCategory) {
      return false;
    }

    // Check price range filter
    if (appliedFilters.isNotEmpty) {
      var minMax = appliedFilters[0].split('-');
      var minPrice = double.parse(minMax[0]);
      var maxPrice = double.parse(minMax[1]);
      var productPrice = double.parse(data['p_price']);

      if (productPrice < minPrice || productPrice > maxPrice) {
        return false;
      }
    }

    // Add any other filter conditions here if needed

    return true;
  }



  getSubCategories(title) async{
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s = decoded.categories.where((element) => element.name == title).toList();

    if (s.isNotEmpty) {
      for (var e in s[0].subcategory) {
        subcat.add(e);
      }
    } else {
      // Handle the case when the category is not found
      print('Category not found for title: $title');
      // You can return an empty list or throw an exception, depending on your use case
      // return [];
    }
  }

  changeColorIndex(index){
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity){
    if(quantity.value<totalQuantity){
      quantity.value++;
    }

  }
  decreaseQuantity(){
    if(quantity.value >0){
      quantity.value--;
    }

  }

  resetQuantity(){
    quantity.value = 0;
  }

  calculateTotalPrice(price){
    totalPrice.value = price * quantity.value;

  }

  addToCart({
    title, img, sellername, color, qty, tprice,context,vendorID}) async{
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellername': sellername,
      'color': color,
      'qty': qty,
      'vendor_id': vendorID,
      'tprice': tprice,
       'added_by': currentUser!.uid
    }).catchError((error){
      VxToast.show(context, msg: error.toString());
    });
  }

  resetValues(){
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  addToWishlist(docId,context) async{
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist' : FieldValue.arrayUnion([currentUser!.uid])
    },SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to wishlist");
  }

  removeFromWishlist(docId,context) async{
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist' : FieldValue.arrayRemove([currentUser!.uid])
    },SetOptions(merge: true));

    isFav(false);
    VxToast.show(context, msg: "Removed from wishlist");
  }

  checkIfFav(data) async{
    if(data['p_wishlist'].contains(currentUser!.uid)){
      isFav(true);
    }else{
      isFav(false);
    }
  }


}