import 'package:atts/Alertbox/common_alert.dart';
import 'package:atts/Controller/Product/product_controller.dart';
import 'package:atts/Reusable/color.dart';
import 'package:atts/Reusable/text_styles.dart';
import 'package:atts/Routes/route.dart';
import 'package:atts/UI/Drawer/Menu/Product/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../../Reusable/fab.dart';
class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ProductController controller = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    controller.fetchProducts();
    return   SafeArea(
      child: Scaffold(
        backgroundColor: appFirstColor,
       floatingActionButton:  CustomFAB(
          onPressed: () {
            controller.clearForm();
          Navigator.pushNamed(context, AttsRoutes.addProductRoute);
          },
          icon: Icons.add,
          backgroundColor: appBottomColor,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        alignment: Alignment.topCenter,
                        "assets/arrow.png",
                        width: size.width * 0.1,
                        height: size.height * 0.05,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Text('Jewellery List',style: MyTextStyle.f24(appBottomColor,weight: FontWeight.bold),)
              ],
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: SpinKitCircle(size: 50,color: appBottomColor,));
                }
              
                if (controller.productList.isEmpty) {
                  return Center(child: Text('No Products Found'));
                }
                // if (controller.productList.isEmpty) {
                //   return Center(child: Text('No Products Found'));
                // }
              
                return ListView.builder(
                  itemCount: controller.productList.length,
                  itemBuilder: (context, index) {
                    final product = controller.productList[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: Image.network(product['imageUrl'], width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(product['name']),
                        subtitle: Text("₹${product['amount']} - ${product['category']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                controller.loadProductForEdit(product);
                                Get.to(() => AddProduct());
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                CommonAlert(
                                  context: context,
                                  title: "Delete",
                                  description: "Are you sure you want to Delete this item?",

                                  onOkPressed: () async {
                                    controller.deleteProduct(product['id'], product['imageUrl']);
                                  },
                                );

                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}