import 'package:atts/Model/product_model.dart';
import 'package:atts/Reusable/color.dart';
import 'package:atts/UI/Landing%20Screen/Home/product_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductGrid extends StatelessWidget {
  final String category;
  const ProductGrid({required this.category});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("products")
          .where("category", isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return const Center(child: Text("Something went wrong!"));
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
          return const Center(child: Text("No Products Found"));

        final products = snapshot.data!.docs.map((doc) {
          return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.70,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailPage(product: product),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: appFirstColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // Image with discount badge
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: CachedNetworkImage(
                                alignment: Alignment.center,
                                height: 150,
                                width: double.infinity,
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
                                    color: appPrimaryColor,
                                    size: 30),
                                imageUrl: product.imageUrl,
                              ),
                            ),
                            // ClipRRect(
                            //   borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            //   child: SizedBox(
                            //     height: 150,
                            //     width: double.infinity,
                            //     child: Image.network(
                            //       product.imageUrl,
                            //       fit: BoxFit.cover,
                            //       errorBuilder: (context, error, stackTrace) =>
                            //           const Icon(Icons.broken_image,
                            //               size: 40, color: Colors.grey),
                            //     ),
                            //   ),
                            // ),
                            if(product.discount != 0.0)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: appButton2Color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "${product.discount}% OFF",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Details section
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(9),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "₹${product.amount}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Add to cart icon
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          color: appBottomColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepOrange.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.double_arrow_outlined,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailPage(product: product),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
