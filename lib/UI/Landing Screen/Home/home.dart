import 'package:atts/Reusable/color.dart';
import 'package:atts/UI/Drawer/drawer.dart';
import 'package:flutter/material.dart';

import 'product_grid.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> categories = ["Gold", "Silver", "Diamond", "Platinum"];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        backgroundColor: appFirstColor,
        key: _scaffoldKey,
        drawer: const CustomDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Categories",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              // TabBar inside body
              TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: categories.map((cat) => Tab(text: cat)).toList(),
              ),

              // TabBarView inside Expanded
              Expanded(
                child: TabBarView(
                  children: categories.map((category) {
                    return ProductGrid(category: category);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
