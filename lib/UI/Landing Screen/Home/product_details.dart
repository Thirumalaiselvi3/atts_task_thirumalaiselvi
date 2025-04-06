import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atts/Model/product_model.dart';
import 'dart:typed_data';
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      floatingActionButton: isBilled
          ? FloatingActionButton.extended(
        onPressed: _generateAndViewPdf,
        icon: Icon(Icons.picture_as_pdf),
        label: Text("Invoice"),
      )
          : null,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -1))
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total: ₹${totalAmount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: isBilled ? null : _storeBillingData,
              child: Text(isBilled ? "Billed" : "Bill Now"),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(widget.product.imageUrl, height: 200)),
            SizedBox(height: 16),
            Text(widget.product.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Price: ₹${widget.product.amount}"),
            Text("Discount: ${widget.product.discount}%",
                textAlign: TextAlign.right),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                  icon: Icon(Icons.remove_circle_outline),
                ),
                Text('$quantity', style: TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: () => setState(() => quantity++),
                  icon: Icon(Icons.add_circle_outline),
                ),
              ],
            ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Billing saved successfully')),
      );
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
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(logoImage, width: 60),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("My Shop", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text("123 Street, City, Country"),
                    pw.Text("Phone: +91 9876543210"),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text("INVOICE", style: pw.TextStyle(fontSize: 24)),
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
