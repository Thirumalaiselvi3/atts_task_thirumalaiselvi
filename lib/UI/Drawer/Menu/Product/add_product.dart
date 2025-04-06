import 'package:atts/Controller/Product/product_controller.dart';
import 'package:atts/Reusable/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class AddProduct extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  final List<String> categories = ["Gold", "Silver", "Diamond", "Platinum"];

  @override
  Widget build(BuildContext context) {
    final isEdit = controller.editingProductId != null;

    return Scaffold(
      backgroundColor: appFirstColor,
      appBar: AppBar(
        backgroundColor: appFirstColor,
        title: Text(isEdit ? 'Edit Product' : 'Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => GestureDetector(
                onTap: () => controller.pickImage(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: controller.imageUrl.value.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          controller.imageUrl.value,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 150,
                        ),
                      )
                          : Center(child: Text("Tap to upload image")),
                    ),

                    if (controller.imageUrl.value.isNotEmpty)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: GestureDetector(
                          onTap: () {
                            controller.imageUrl.value = '';
                            controller.selectedImage = null;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close, color: Colors.white, size: 20),
                          ),
                        ),
                      ),

                    // Show progress indicator while uploading
                    if (controller.isUploading.value)
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: appFirstColor,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: SpinKitCircle(color: appBottomColor,size: 50,)),
                      ),
                  ],
                ),
              )),

              // GestureDetector(
              //   onTap: () => controller.pickImage(),
              //   child: Stack(
              //     children: [
              //       Container(
              //         height: 150,
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //           border: Border.all(),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: controller.imageUrl.value.isNotEmpty
              //             ? ClipRRect(
              //           borderRadius: BorderRadius.circular(10),
              //           child: Image.network(
              //             controller.imageUrl.value,
              //             fit: BoxFit.cover,
              //             width: double.infinity,
              //             height: 150,
              //           ),
              //         )
              //             : Center(child: Text("Tap to upload image")),
              //       ),
              //       if (controller.imageUrl.value.isNotEmpty)
              //         Positioned(
              //           top: 4,
              //           left: 4,
              //           child: GestureDetector(
              //             onTap: () {
              //               controller.imageUrl.value = '';
              //               controller.selectedImage = null;
              //             },
              //             child: Container(
              //               decoration: BoxDecoration(
              //                 color: Colors.black.withOpacity(0.5),
              //                 shape: BoxShape.circle,
              //               ),
              //               child: Icon(
              //                 Icons.close,
              //                 color: Colors.white,
              //                 size: 20,
              //               ),
              //             ),
              //           ),
              //         ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: controller.name.value,
                decoration: InputDecoration(labelText: "Product Name"),
                onChanged: (val) => controller.name.value = val,
              ),
              TextFormField(
                initialValue: controller.amount.value,
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                onChanged: (val) => controller.amount.value = val,
              ),
              TextFormField(
                initialValue: controller.discount.value,
                decoration: InputDecoration(labelText: "Discount %"),
                keyboardType: TextInputType.number,
                onChanged: (val) => controller.discount.value = val,
              ),
              DropdownButtonFormField<String>(
                value: controller.category.value.isEmpty
                    ? null
                    : controller.category.value,
                items: categories.map((String cat) {
                  return DropdownMenuItem<String>(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                hint: Text("Select Category"),
                onChanged: (val) {
                  if (val != null) controller.category.value = val;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => controller.saveProduct(),
                child: Text(isEdit ? "Update Product" : "Save Product"),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
