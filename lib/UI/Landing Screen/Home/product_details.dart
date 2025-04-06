import 'package:atts/Reusable/color.dart';
import 'package:atts/Reusable/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atts/Model/product_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  bool isBilled = false;

  double get discountedPrice {
    double original = double.tryParse(widget.product.amount.toString()) ?? 0.0;
    double discount = widget.product.discount ?? 0.0;
    return original - (original * discount / 100);
  }

  double get taxAmount => discountedPrice * 0.18;
  double get totalAmount => (discountedPrice + taxAmount) * quantity;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appFirstColor, 
      // floatingActionButton: isBilled
      //     ? FloatingActionButton.extended(
      //   onPressed: _generateAndViewPdf,
      //   backgroundColor: appButton2Color,
      //   icon: Icon(Icons.picture_as_pdf,color: appBottomColor,),
      //   label: Text("Invoice",style: MyTextStyle.f16(whiteColor),),
      // )
      //     : null,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: appBottomColor, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -1))
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total: ₹${totalAmount.toStringAsFixed(2)}",
                style: MyTextStyle.f20(whiteColor,weight: FontWeight.bold)),
            isBilled? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appButton1Color, // Disabled vs active color
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              onPressed:   _generateAndViewPdf,
              child: Text(  "View Invoice",style: MyTextStyle.f16(blackColor),),
            ):
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isBilled ? Colors.grey :appButton2Color, // Disabled vs active color
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              onPressed: isBilled ? null : _storeBillingData,
              child: Text(isBilled ? "Billed" : "Bill Now",style: MyTextStyle.f16(   whiteColor),),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text('Jewellery Detail',style: MyTextStyle.f24(appBottomColor,weight: FontWeight.bold),)
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color:  appBottomColor,
                      width: 2, // Border width
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      alignment: Alignment.center,
                      height: 300,
                      width:double.infinity,
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
                          color: appPrimaryColor, size: 50),
                      imageUrl: widget.product.imageUrl
                    ),
                  ),
                ),
              ),
              // Center(child: Image.network(widget.product.imageUrl, height: 200,width: double.infinity,)),
              SizedBox(height: 5),
              Divider(color: appBottomColor,endIndent: 15,indent: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text('Product Name : ${widget.product.name}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            Divider(color: appBottomColor,endIndent: 15,indent: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text("Price: ₹${widget.product.amount}"),
                            Text("Discount: ${widget.product.discount}%",
                                textAlign: TextAlign.right),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                              icon: Icon(Icons.remove_circle,color: Colors.red.shade900,),
                            ),
                            Text('$quantity', style: TextStyle(fontSize: 18)),
                            IconButton(
                              onPressed: () => setState(() => quantity++),
                              icon: Icon(Icons.add_circle,color: Colors.green.shade900,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Divider(color: appBottomColor,),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Price After Discount: ₹${discountedPrice.toStringAsFixed(2)}"),
                        Text("Tax (18%): ₹${taxAmount.toStringAsFixed(2)}"),
                      ],
                    ),
                  ),
                ],
              ),
            )
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _storeBillingData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid'); // assuming your UID key is 'uid'

    if (uid == null) {
      // Handle the case when UID is not found
      print('User ID not found in SharedPreferences');
      return;
    }

    try {
      // Fetch user details from Firestore
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        print('User not found in Firestore');
        return;
      }

      final userData = userDoc.data();

      final billingData = {
        'productName': widget.product.name,
        'quantity': quantity,
        'price': widget.product.amount,
        'imageUrl': widget.product.imageUrl,
        'category': widget.product.category,
        'discount': widget.product.discount,
        'priceAfterDiscount': discountedPrice,
        'tax': taxAmount,
        'totalAmount': totalAmount,
        'timestamp': FieldValue.serverTimestamp(),

        // User Info
        'userId': uid,
        'username': userData?['username'],
        'phone': userData?['phone'],
        'address': userData?['address'],
      };

      await FirebaseFirestore.instance.collection('billing').add(billingData);

      setState(() => isBilled = true);
      Get.snackbar("Success", "Billing has been successfully saved. Please download or view your invoice below.");
    } catch (e) {
      print('Error storing billing data: $e');
    }
  }

  Future<void> _generateAndViewPdf() async {
    final pdf = pw.Document();
    final logo = await rootBundle.load('assets/logo.png');
    final logoImage = pw.MemoryImage(logo.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Image(logoImage, width: 60),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [

                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text("ATTS JEWELLERY", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text("ABC Street, Tenkasi, Tamil Nadu"),
                    pw.Text("Phone: +91 87547 22940"),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text("INVOICE", style: pw.TextStyle(fontSize: 20)),
            pw.Row(
              children: [
                pw.Spacer(), // Pushes the text to the right
                pw.Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                  style: pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Spacer(), // Pushes the text to the right
                pw.Text(
                 "Time: ${DateFormat('HH:mm').format(DateTime.now())}",
                  style: pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Product', 'Qty', 'Unit Price', 'Discount', 'Price', 'Tax', 'Total'],
              data: [
                [
                  widget.product.name,
                  quantity.toString(),
                  'Rs.${widget.product.amount}',
                  '${widget.product.discount}%',
                  'Rs.${discountedPrice.toStringAsFixed(2)}',
                  'Rs.${taxAmount.toStringAsFixed(2)}',
                  'Rs.${totalAmount.toStringAsFixed(2)}',
                ]
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text("Grand Total: Rs.${totalAmount.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            )
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
