import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageAdmin extends StatefulWidget {
  PageAdmin({Key? key});

  @override
  State<PageAdmin> createState() => _PageAdminState();
}

class _PageAdminState extends State<PageAdmin> {
  List<Map<String, dynamic>> menu = [];
  bool statusLogin = false;
  String email = '';
  String name = '';

  @override
  void initState() {
    super.initState();
    setMenu();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        statusLogin = prefs.getBool('isLogin') ?? false;
      });
    });
  }

  Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  setMenu() {
    isLogin().then((bool statusLogin) {
      setState(() {
        menu = [
          {
            'name': 'Add Events',
            'icon': Icons.event_available_rounded,
            'route': '/addEvents'
          },
          {
            'name': 'Add Wisata',
            'icon': Icons.location_city_rounded,
            'route': '/addWisata'
          },
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: List.generate(
                      menu.length,
                      (index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Future.delayed(
                                  const Duration(milliseconds: 150),
                                  () {
                                    Navigator.pushNamed(
                                      context,
                                      menu[index]['route'],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border(
                                    top: BorderSide(color: Colors.grey[300]!),
                                    bottom:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                                padding: EdgeInsets.only(
                                  top: 15,
                                  bottom: 15,
                                  left: 8,
                                  right: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(menu[index]['icon']),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 8.0),
                                          child: Text(menu[index]['name']),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Icon(Icons.arrow_forward_ios),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
