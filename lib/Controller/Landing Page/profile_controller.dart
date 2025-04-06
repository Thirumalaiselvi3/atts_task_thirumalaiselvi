import 'package:atts/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var user = Rxn<UserModel>();       // Observable user model
  var isLoading = true.obs;          // Loading indicator

  final String userId;               // User ID passed to controller

  // Constructor to receive userId
  ProfileController(this.userId);

  @override
  void onInit() {
    super.onInit();
    fetchUserData(userId);           // Fetch user data on controller init
  }

  // Fetch user data from Firestore
  void fetchUserData(String userID) async {
    isLoading.value = true;

    try {
      print('ProfileController: Fetching user with ID => $userID');

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();

      if (doc.exists) {
        user.value = UserModel.fromMap(doc.data()!);
        print('User data fetched successfully');
      } else {
        print('No user found with this ID');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
