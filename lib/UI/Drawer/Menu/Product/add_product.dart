import 'package:atts/Controller/Product/product_controller.dart';
import 'package:atts/Reusable/button.dart';
import 'package:atts/Reusable/color.dart';
import 'package:atts/Reusable/customTextfield.dart';
import 'package:atts/Reusable/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class AddProduct extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  final List<String> categories = ["Gold", "Silver", "Diamond", "Platinum"];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isEdit = controller.editingProductId != null;
    return SafeArea(
      child: Scaffold(
        backgroundColor: appFirstColor,
      
        body: Obx(() => SingleChildScrollView(
          child: Column(
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
                  Text(isEdit ? 'Edit Jewellery' : 'Add Jewellery',style: MyTextStyle.f24(appBottomColor,weight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 20,),
              Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: GestureDetector(
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
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Column(
                 children: [
                   const SizedBox(height: 10),
                   TextFormField(
                     initialValue: controller.name.value,
                     decoration: customInputDecoration("Product Name"),
                     onChanged: (val) => controller.name.value = val,
                   ),
                   SizedBox(height: 15,),
                   TextFormField(
                     initialValue: controller.amount.value,
                     decoration: customInputDecoration("Amount"),
                     keyboardType: TextInputType.number,
                     onChanged: (val) => controller.amount.value = val,
                   ),
                   SizedBox(height: 15,),
                   TextFormField(
                     initialValue: controller.discount.value,
                     decoration: customInputDecoration("Discount %"),
                     keyboardType: TextInputType.number,
                     onChanged: (val) => controller.discount.value = val,
                   ),
                   SizedBox(height: 15,),
                   DropdownButtonHideUnderline(
                     child: DropdownButtonFormField<String>(
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
                       decoration: InputDecoration(
                         hintText: "Select Category",
                         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                           borderSide: BorderSide(color: appBottomColor, width: 1),
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                           borderSide: BorderSide(color: appButton2Color, width: 2),
                         ),
                       ),
                     ),

                   ),
                   const SizedBox(height: 30),
                   appButton(
                       onTap:  () => controller.saveProduct(),
                       height: 50,
                       width: size.width * 0.90,
                       color: whiteColor,
                       buttonText:isEdit ? "Update Jewellery" : "Save Jewellery"),

                 ],
               ),
             )
            ],
          ),
        )),
      ),
    );
  }
}
