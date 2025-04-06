import 'dart:io';
import 'package:atts/UI/Drawer/Menu/Product/product_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  var name = ''.obs;
  var amount = ''.obs;
  var discount = ''.obs;
  var category = ''.obs;
  var imageUrl = ''.obs;
  var isLoading = true.obs;
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;

  RxList<Map<String, dynamic>> productList = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? editingProductId;

  // Fetch all products
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final query = await _db.collection('products').orderBy('createdAt', descending: true).get();

      productList.value = query.docs.map((doc) => {
        ...doc.data(),
        'id': doc.id,
      }).toList();
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }


  // Pick image from gallery
  var isUploading = false.obs;

  Future<void> pickImage() async {
    try {
      isUploading.value = true; // Start loader

      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage = image;
        await uploadImageToFirebase();
      }
    } catch (e) {
      print("Error picking/uploading image: $e");
    } finally {
      isUploading.value = false; // Stop loader
    }
  }

  // Future<void> pickImage() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     selectedImage = image;
  //     await uploadImageToFirebase();
  //   }
  // }

  // Upload to Firebase and get URL
  Future<void> uploadImageToFirebase() async {
    if (selectedImage == null) return;
    final file = File(selectedImage!.path);
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final ref = _storage.ref().child('product_images/$fileName');
    await ref.putFile(file);
    final downloadURL = await ref.getDownloadURL();
    imageUrl.value = downloadURL;
  }

  // Load product into form for editing
  void loadProductForEdit(Map<String, dynamic> product) {
    name.value = product['name'];
    amount.value = product['amount'].toString();
    discount.value = product['discount'].toString();
    category.value = product['category'];
    imageUrl.value = product['imageUrl'];
    editingProductId = product['id'];
  }

  // Clear form fields
  void clearForm() {
    name.value = '';
    amount.value = '';
    discount.value = '';
    category.value = '';
    imageUrl.value = '';
    selectedImage = null;
    editingProductId = null;
  }

  // Save (Add/Edit) product
  Future<void> saveProduct() async {
    if (name.isEmpty || amount.isEmpty || category.isEmpty || imageUrl.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    final data = {
      'name': name.value,
      'amount': double.tryParse(amount.value) ?? 0.0,
      'discount': double.tryParse(discount.value) ?? 0.0,
      'category': category.value,
      'imageUrl': imageUrl.value,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      if (editingProductId != null) {
        await _db.collection('products').doc(editingProductId).update(data);
        Get.back();
        Get.snackbar("Updated", "Product updated successfully");
      } else {
        await _db.collection('products').add(data);
        Get.back();
        Get.snackbar("Added", "Product added successfully");
      }

      clearForm();
      fetchProducts();
      Get.back(); // Close the form screen
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }

  // Delete a product
  Future<void> deleteProduct(String id, String imageUrl) async {
    try {
      await _db.collection('products').doc(id).delete();

      // Delete image from Firebase Storage
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();

      fetchProducts();
      Get.snackbar("Deleted", "Jewellery deleted Successfully..");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete product");
    }
  }
}
