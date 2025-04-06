import 'package:atts/Alertbox/common_alert.dart';
import 'package:atts/Controller/Product/product_controller.dart';
import 'package:atts/Reusable/color.dart';
import 'package:atts/Reusable/text_styles.dart';
import 'package:atts/Routes/route.dart';
import 'package:atts/UI/Drawer/Menu/Product/add_product.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: appFirstColor,
        floatingActionButton: CustomFAB(
          onPressed: () {
            controller.clearForm();
            Navigator.pushNamed(context, AttsRoutes.addProductRoute);
          },
          icon: Icons.add,
          backgroundColor: appButton2Color,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
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
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Jewellery List',
                  style:
                      MyTextStyle.f24(appBottomColor, weight: FontWeight.bold),
                )
              ],
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                      child: SpinKitCircle(
                    size: 50,
                    color: appBottomColor,
                  ));
                }

                if (controller.productList.isEmpty) {
                  return Center(child: Text('No Products Found'));
                }

                return ListView.builder(
                  itemCount: controller.productList.length,
                  itemBuilder: (context, index) {
                    final product = controller.productList[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: appBottomColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
                                  fit: BoxFit.fill,
                                  errorWidget: (context, url, error) {
                                    return const Icon(
                                      Icons.error,
                                      size: 30,
                                      color: appButton2Color,
                                    );
                                  },
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          const SpinKitCircle(
                                              color: appPrimaryColor, size: 30),
                                  imageUrl: product['imageUrl'],
                                ),
                              ),
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(12),
                              //   child: Image.network(
                              //     product['imageUrl'],
                              //     width: 60,
                              //     height: 60,
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product['name'],
                                        style: MyTextStyle.f20(appButton1Color,
                                            weight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text(
                                        "₹${product['amount']} - ${product['category']}",
                                        style: MyTextStyle.f16(
                                          amberColor,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: amberColor,
                              ),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  controller.loadProductForEdit(product);
                                  Get.to(() => AddProduct());
                                } else if (value == 'delete') {
                                  CommonAlert(
                                    context: context,
                                    title: "Delete",
                                    description:
                                        "Are you sure you want to delete this item?",
                                    onOkPressed: () async {
                                      controller.deleteProduct(
                                          product['id'], product['imageUrl']);
                                      Navigator.pop(context);
                                    },
                                  );
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: appBottomColor),
                                      SizedBox(width: 8),
                                      Text('Edit',
                                          style:
                                              MyTextStyle.f14(appBottomColor)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: appBottomColor),
                                      SizedBox(width: 8),
                                      Text(
                                        'Delete',
                                        style: MyTextStyle.f14(appBottomColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                    // return Card(
                    //   margin: EdgeInsets.all(10),
                    //   child: ListTile(
                    //     leading: Image.network(product['imageUrl'], width: 50, height: 50, fit: BoxFit.cover),
                    //     title: Text(product['name']),
                    //     subtitle: Text("₹${product['amount']} - ${product['category']}"),
                    //     trailing: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         IconButton(
                    //           icon: Icon(Icons.edit, color: Colors.blue),
                    //           onPressed: () {
                    //             controller.loadProductForEdit(product);
                    //             Get.to(() => AddProduct());
                    //           },
                    //         ),
                    //         IconButton(
                    //           icon: Icon(Icons.delete, color: Colors.red),
                    //           onPressed: () {
                    //             CommonAlert(
                    //               context: context,
                    //               title: "Delete",
                    //               description: "Are you sure you want to Delete this item?",
                    //
                    //               onOkPressed: () async {
                    //                 controller.deleteProduct(product['id'], product['imageUrl']);
                    //               },
                    //             );
                    //
                    //           },
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // );
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
