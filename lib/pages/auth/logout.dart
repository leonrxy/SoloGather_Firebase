import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  late SharedPreferences prefs;

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> clearLoginStatus() async {
    prefs.setBool('isLogin', false);
    prefs.setString('userEmail', '');
    prefs.setString('userName', '');
    prefs.setString('userUid', '');
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      clearLoginStatus();

      // Use Navigator.pop to go back to the Profil screen
      Navigator.pop(context);

      // Use Navigator.pushReplacementNamed to replace the current route with a new instance of Profil
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shadowColor: Colors.grey,
      title: Text('Konfirmasi Logout'),
      content: Text('Anda yakin ingin logout?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Tutup modal
          },
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            logout();
          },
          child: Text('Logout'),
        ),
      ],
    );
  }
}
