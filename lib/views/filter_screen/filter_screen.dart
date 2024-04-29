import 'package:flutter/material.dart';

import '../../consts/colors.dart';

// Define a custom callback type for filter application
typedef FilterCallback = void Function(
    double minPrice, double maxPrice, List<int> selectedColors, List<String> selectedMaterials,List<String> selectedInteriorStyles);

class FilterScreen extends StatefulWidget {
  final FilterCallback onApplyFilters;
  final double initialMinPrice;
  final double initialMaxPrice;
  final List<int> initialSelectedColors;
  final List<String> initialSelectedMaterials;
  final List<String> initialSelectedInteriorStyles;
  final List<String> materialsList;
  final List<String> interiorStylesList; // List of materials for the product category

  const FilterScreen({super.key, 
    required this.onApplyFilters,
    required this.initialMinPrice,
    required this.initialMaxPrice,
    required this.initialSelectedColors,
    required this.initialSelectedMaterials,
    required this.materialsList,
    required this.initialSelectedInteriorStyles,
    required this.interiorStylesList,
  });

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late double _minPrice;
  late double _maxPrice;
  late List<int> _selectedColors;
  late List<String> _selectedMaterials;
  late List<String> _selectedInteriorStyles;

  final Map<int, String> colorMap = {
    4294198070: 'Red',
    4284782061: 'Blue',
    4278224287: 'Green',
    4294956800: 'Yellow'
    // Add more color numbers and their corresponding names as needed
  };

  @override
  void initState() {
    super.initState();
    // Set initial filter values
    _minPrice = widget.initialMinPrice;
    _maxPrice = widget.initialMaxPrice;
    _selectedColors = widget.initialSelectedColors;
    _selectedMaterials = widget.initialSelectedMaterials;
    _selectedInteriorStyles = widget.initialSelectedInteriorStyles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Range',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: redColor),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Min Price: ${_minPrice.toStringAsFixed(0)}',
                  style: const TextStyle(color: redColor),
                ),
                Slider(
                  min: 0,
                  max: 100000,
                  divisions: 50,
                  activeColor: redColor,
                  inactiveColor: Colors.blueGrey,
                  value: _minPrice,
                  onChanged: (value) {
                    setState(() {
                      _minPrice = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Max Price: ${_maxPrice.toStringAsFixed(0)}',
                  style: const TextStyle(color: redColor),
                ),
                Slider(
                  min: 0,
                  max: 100000,
                  divisions: 50,
                  activeColor: redColor,
                  inactiveColor: Colors.blueGrey,
                  value: _maxPrice,
                  onChanged: (value) {
                    setState(() {
                      _maxPrice = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Colors',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: redColor),
            ),
            // Display color checkboxes fetched from the color map
            ...colorMap.entries.map((entry) {
              return CheckboxListTile(
                activeColor: redColor,
                title: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: Color(entry.key), // Use color number as background color
                    ),
                    const SizedBox(width: 10),
                    Text(entry.value),
                  ],
                ),
                value: _selectedColors.contains(entry.key),
                onChanged: (value) {
                  setState(() {
                    value!
                        ? _selectedColors.add(entry.key)
                        : _selectedColors.remove(entry.key);
                  });
                },
              );
            }),
            const SizedBox(height: 20),
            const Text(
              'Materials',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: redColor),
            ),
            // Display materials checkboxes based on the materials list for the product category
            ...widget.materialsList.map((material) {
              return CheckboxListTile(
                activeColor: redColor,
                title: Text(material),
                value: _selectedMaterials.contains(material),
                onChanged: (value) {
                  setState(() {
                    value!
                        ? _selectedMaterials.add(material)
                        : _selectedMaterials.remove(material);
                  });
                },
              );
            }),
            const SizedBox(height: 20),
            const Text(
              'Interior Styles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: redColor),
            ),
            ...widget.interiorStylesList.map((style) {
              return CheckboxListTile(
                activeColor: redColor,
                title: Text(style),
                value: _selectedInteriorStyles.contains(style),
                onChanged: (value) {
                  setState(() {
                    value! ? _selectedInteriorStyles.add(style) : _selectedInteriorStyles.remove(style);
                  });
                },
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                widget.onApplyFilters(
                  _minPrice,
                  _maxPrice,
                  _selectedColors,
                  _selectedMaterials,
                  _selectedInteriorStyles
                );
                Navigator.pop(context); // Close the filter screen
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(redColor),
              ),
              child: const Text('Apply Filters', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                // Reset filters
                setState(() {
                  _minPrice = 0;
                  _maxPrice = 100000;
                  _selectedColors.clear();
                  _selectedMaterials.clear();
                  _selectedInteriorStyles.clear();
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(redColor),
              ),
              child: const Text('Reset Filters', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

