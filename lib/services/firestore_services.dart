import 'package:furniture_user_side/consts/consts.dart';

class FirestoreServices {
  //get users data
  static getUser(uid) {
    return firestore
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  // get products according to category with filters
  static getProducts(category,
      {RangeValues? priceRange,
        String? selectedColor,
        List<String>? selectedVariants,
        List<String>? selectedBrands}) {
    var query = firestore.collection(productsCollection).where('p_category', isEqualTo: category);

    if (priceRange != null) {
      query = query.where('p_price', isGreaterThanOrEqualTo: priceRange.start, isLessThanOrEqualTo: priceRange.end);
    }

    if (selectedColor != null && selectedColor.isNotEmpty) {
      query = query.where('p_color', isEqualTo: selectedColor);
    }

    if (selectedVariants != null && selectedVariants.isNotEmpty) {
      query = query.where('p_variant', whereIn: selectedVariants);
    }

    if (selectedBrands != null && selectedBrands.isNotEmpty) {
      query = query.where('p_brand', whereIn: selectedBrands);
    }

    return query.snapshots();
  }

  // get subcategory products with filters
  static getSubCategoryProducts(title,
      {RangeValues? priceRange,
        String? selectedColor,
        List<String>? selectedCategories,
        List<String>? selectedBrands}) {
    var query = firestore.collection(productsCollection).where('p_subcategory', isEqualTo: title);

    if (priceRange != null) {
      query = query.where('p_price', isGreaterThanOrEqualTo: priceRange.start, isLessThanOrEqualTo: priceRange.end);
    }

    if (selectedColor != null && selectedColor.isNotEmpty) {
      query = query.where('p_color', isEqualTo: selectedColor);
    }

    if (selectedCategories != null && selectedCategories.isNotEmpty) {
      query = query.where('p_categories', whereIn: selectedCategories);
    }

    if (selectedBrands != null && selectedBrands.isNotEmpty) {
      query = query.where('p_brand', whereIn: selectedBrands);
    }

    return query.snapshots();
  }

  // // get products according to category
  // static getProducts(category) {
  //   return firestore
  //       .collection(productsCollection)
  //       .where('p_category', isEqualTo: category)
  //       .snapshots();
  // }
  // static getSubCategoryProducts(title){
  //   return firestore
  //       .collection(productsCollection)
  //       .where('p_subcategory', isEqualTo: title)
  //       .snapshots();
  // }

  //get cart

  static getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  // delete document

  static deleteDociment(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  // get all chat messages

  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messageCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }
  static getAllOrders(){
    return firestore.collection(ordersCollection).where('order_by',isEqualTo: currentUser!.uid).snapshots();
  }

  static getWishlists(){
    return firestore.collection(productsCollection).where('p_wishlist',arrayContains: currentUser!.uid).snapshots();
  }

  static getAllMessages(){
    return firestore
        .collection(chatsCollection).where('fromId',isEqualTo: currentUser!.uid).snapshots();
  }

  static getCounts() async{
    var res = await Future.wait([
      firestore.collection(cartCollection).where('added_by',isEqualTo: currentUser!.uid).get().then((value) {
        return value.docs.length;
      }),
      firestore.collection(productsCollection).where('p_wishlist',arrayContains: currentUser!.uid).get().then((value) {
        return value.docs.length;
      }),
      firestore.collection(ordersCollection).where('order_by',isEqualTo: currentUser!.uid).get().then((value) {
        return value.docs.length;
      })
    ]);
    return res;
  }

  static allProducts(){
    return firestore.collection(productsCollection).snapshots();
  }

  // get featured products method
  static getFeaturedProducts(){
    return firestore.collection(productsCollection).where('is_featured',isEqualTo: true).get();
  }

  // product u may also like
  static getProductsYouLike(){
    return firestore.collection(productsCollection).where('is_product',isEqualTo: true).get();
  }

  static searchProducts(title){
    return firestore.collection(productsCollection).get();
  }



}
