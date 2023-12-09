import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginSession with ChangeNotifier {
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  void setLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  static Future<String?> getNameFromEmail(String userEmail) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: userEmail)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there is only one user with the given email
        var userData = querySnapshot.docs.first.data();
        String name = userData['name'];
        return name;
      } else {
        // No user found with the given email
        return null;
      }
    } catch (e) {
      print('Error getting user name: $e');
      return null;
    }
  }
}
