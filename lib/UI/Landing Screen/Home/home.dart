import 'package:flutter/material.dart';
import 'package:atts/Reusable/carousel_slider.dart';
import 'package:atts/Reusable/color.dart';
import 'package:atts/UI/Drawer/drawer.dart';
import 'product_grid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Category list with icons
  final List<Map<String, dynamic>> categories = [
    {"title": "Gold", "image": "assets/gold.png"},
    {"title": "Silver", "image": "assets/silver1.png"},
    {"title": "Diamond", "image": "assets/diamond.png"},
    {"title": "Platinum", "image": "assets/platinum3.png"},
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appFirstColor,
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Icon
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: IconButton(
                icon: const Icon(Icons.sort, size: 28),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),

            // App Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "CRUD Jewellery",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Carousel Slider
            CarouselSliderWidget(
              imageUrls: [
                'assets/slider1.png',
                'assets/slider2.png',
                'assets/slider3.png',
              ],
            ),

            const SizedBox(height: 15),

            // Category Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Category cards as horizontal list
            SizedBox(
              height: 77,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  bool isSelected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      width: 77,

                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? appBottomColor:appFirstColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            categories[index]['image'],
                            height: 40,
                            width: 40,
                          ),

                          Text(
                            categories[index]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Product Grid for selected category
            Expanded(
              child: ProductGrid(
                category: categories[selectedIndex]['title'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
