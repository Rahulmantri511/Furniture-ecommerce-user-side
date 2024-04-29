import 'package:furniture_user_side/views/filter_screen/filter_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_user_side/consts/consts.dart';
import 'package:furniture_user_side/controllers/product_controller.dart';
import 'package:furniture_user_side/services/firestore_services.dart';
import 'package:furniture_user_side/views/category_screen/item_details.dart';
import 'package:furniture_user_side/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';
import '../cart_screen/cart_screen.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;
  final List<String> subcategories;

  const CategoryDetails({super.key, required this.title, required this.subcategories});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  double _minPrice = 0;
  double _maxPrice = 100000;
  List<int> _selectedColors = [];
  List<String> _selectedMaterials = [];
  List<String> _selectedInteriorStyles = [];

  var controller = Get.find<ProductController>();
  dynamic productMethod;

  @override
  void initState() {
    switchCategory(widget.title);
    super.initState();
  }

  switchCategory(title) {
    setState(() {
      if (controller.subcat.contains(title)) {
        productMethod = FirestoreServices.getSubCategoryProducts(title);
      } else {
        productMethod = FirestoreServices.getProducts(title);
        controller.resetFiltersForCategory(title);
      }
      controller.selectedCategory = title; // Set the selected category
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title!,
          style: const TextStyle(
            fontFamily: bold,
            color: redColor,
          ),
        ),
        actions: [
          IconButton(onPressed: () => Get.to(() => const CartScreen()), icon: const Icon(Icons.shopping_cart)),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              if (controller.selectedCategory == widget.title) {
                // Pass the category-specific materials and interior styles lists to the FilterScreen
                List<String> materialsList = _getMaterialsListForCategory(widget.title!);
                List<String> interiorStylesList = _getInteriorStylesListForCategory(widget.title!);
                await Get.to(() => FilterScreen(
                  onApplyFilters: (minPrice, maxPrice, selectedColors, selectedMaterials, selectedInteriorStyles) {
                    setState(() {
                      _minPrice = minPrice;
                      _maxPrice = maxPrice;
                      _selectedColors = selectedColors;
                      _selectedMaterials = selectedMaterials;
                      _selectedInteriorStyles = selectedInteriorStyles;
                    });
                    switchCategory(widget.title);
                  },
                  initialMinPrice: _minPrice,
                  initialMaxPrice: _maxPrice,
                  initialSelectedColors: _selectedColors,
                  initialSelectedMaterials: _selectedMaterials,
                  initialSelectedInteriorStyles: _selectedInteriorStyles,
                  materialsList: materialsList,
                  interiorStylesList: interiorStylesList,
                ));
              }
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(
                controller.subcat.length,
                    (index) => controller.subcat[index]
                    .text
                    .size(12)
                    .center
                    .fontFamily(semibold)
                    .color(Colors.white)
                    .makeCentered()
                    .box
                    .color(Colors.grey)
                    .rounded
                    .size(120, 60)
                    .margin(const EdgeInsets.symmetric(horizontal: 6))
                    .make()
                    .onTap(() {
                  switchCategory(controller.subcat[index]);
                }),
              ),
            ),
          ),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: productMethod,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Expanded(
                  child: Center(
                    child: loadingIndicator(),
                  ),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Expanded(
                  child: "No products found".text.color(darkFontGrey).makeCentered(),
                );
              } else {
                var data = snapshot.data!.docs;
                var filteredData = data.where((product) {
                  var categoryMatches = controller.subcat.contains(widget.title) || product['p_category'] == widget.title;

                  // Convert product price to double
                  double productPrice;
                  try {
                    productPrice = double.parse(product['p_price']);
                  } catch (e) {
                    // Handle conversion errors (e.g., invalid price format)
                    print('Error parsing price for product: ${product['p_name']}');
                    return false;
                  }

                  // Convert min and max prices to double
                  double minPrice;
                  double maxPrice;
                  try {
                    minPrice = double.parse(_minPrice.toString());
                    maxPrice = double.parse(_maxPrice.toString());
                  } catch (e) {
                    // Handle conversion errors (e.g., invalid min or max price format)
                    print('Error parsing min or max price: $e');
                    return false;
                  }

                  // Debug statements to inspect parsed prices

                  // Ensure product price falls within the selected range
                  var priceMatches = productPrice >= minPrice && productPrice <= maxPrice;

                  var colorMatches = _selectedColors.isEmpty || product['p_colors'].any((colorNumber) => _selectedColors.contains(colorNumber));

                  var materialMatches = _selectedMaterials.isEmpty || _selectedMaterials.any((material) => product['p_material'].contains(material));

                  var interiorStyleMatches = _selectedInteriorStyles.isEmpty || _selectedInteriorStyles.any((style) => product['p_interior_style'].contains(style));

                  return categoryMatches && priceMatches && colorMatches && materialMatches && interiorStyleMatches;
                }).toList();

                return Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredData.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 320,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            filteredData[index]['p_imgs'][0],
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
                          ).box.shadowSm.roundedSM.border(width: 1).make(),
                          const SizedBox(height: 10),
                          "${filteredData[index]['p_name']}".text.size(10).color(darkFontGrey).make(),
                          const SizedBox(height: 10),
                          VxRating(
                            isSelectable: false,
                            value: double.parse(data[index]['p_rating']),
                            onRatingUpdate: (value) {},
                            normalColor: textfieldGrey,
                            selectionColor: golden,
                            count: 5,
                            maxRating: 5,
                            size: 15,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text(
                                "₹ ",
                                style: TextStyle(color: redColor, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${filteredData[index]['p_price']}".numCurrency,
                                style: const TextStyle(color: redColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )

                        ],
                      )
                          .box
                          .padding(const EdgeInsets.all(12))
                          .make()
                          .onTap(() {
                        controller.checkIfFav(filteredData[index]);
                        Get.to(() => ItemDetails(title: "${filteredData[index]['p_name']}", data: filteredData[index]));
                      });
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Function to get the materials list based on the category
  List<String> _getMaterialsListForCategory(String category) {
    // Add logic to return appropriate materials list based on the category
    switch (category) {
      case 'Chair':
        return ['Cotton/Poly blend', 'Faux Suede', 'Leather']; // Example list for chairs
      case 'Bed':
        return ['Cotton/Poly blend', 'Faux Suede', 'Leather','Cane'];
      case 'Sofa':
        return ['Cotton/Poly blend', 'Faux Suede', 'Leather'];
      case 'TV Console':
        return ['Hardwood'];
      case 'Dining Table':
        return ['Hardwood','Marble top', 'Metal Legs'];
      case 'Bed Side Table':
        return ['MDF','Hardwood'];
      case 'Pouffe':
        return ['Cotton/Poly blend', 'Faux Suede', 'Leather'];
      case 'TV Unit':
        return ['Laminate', 'Marble', 'Metal','MDF'];
      case 'Center Table':
        return ['Hardwood','Glasstop'];
    // Add cases for other categories as needed
      default:
        return []; // Default empty list
    }
  }

  // Function to get the interior styles list based on the category
  List<String> _getInteriorStylesListForCategory(String category) {
    // Add logic to return appropriate interior styles list based on the category
    switch (category) {
      case 'Chair':
        return ['Scandinavian', 'Minimal', 'Art Modern', 'Contemporary']; // Example list for chairs
      case 'Bed':
        return ['Contemporary', 'Scandinavian', 'Minimal'];
      case 'Sofa':
        return ['Art Modern', 'Traditional'];
      case 'TV Console':
        return ['Art Moderne', 'Minimal', 'Industrial','Hardwood'];
      case 'Dining Table':
        return ['Scandinavian', 'Art Moderne'];
      case 'Bed Side Table':
        return ['Minimal', 'Industrial', 'Art Modern'];
      case 'Pouffe':
        return ['Art Moderne'];
      case 'TV Unit':
        return ['Art Moderne', 'Scandinavian', 'Asian','Contemporary','Laminate', 'MDF', 'Metal'];
      case 'Center Table':
        return ['Industrial', 'Coastal Tropical', 'Art Moderne', 'Minimal', 'Asian', 'Scandinavian',];
    // Add cases for other categories as needed
      default:
        return []; // Default empty list
    }
  }
}
