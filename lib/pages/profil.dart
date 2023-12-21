import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sologather/get_data/loginSession.dart';

class Profil extends StatefulWidget {
  Profil({Key? key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  List<Map<String, dynamic>> menu = [];
  bool statusLogin = false;
  String email = '';
  String name = '';

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getProfil();
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

  Future<void> getProfil() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('userEmail') ?? '';
    print('Email' + email);
    name = prefs.getString('userName') ?? '';
    print('Name' + name);
  }

  setMenu() {
    isLogin().then((bool statusLogin) {
      setState(() {
        menu = statusLogin
            ? [
                {'name': 'Profil', 'icon': Icons.person, 'route': '/profilku'},
                {
                  'name': 'Favoritku',
                  'icon': Icons.favorite,
                  'route': '/favoritku'
                },
                {
                  'name': 'Pengaturan',
                  'icon': Icons.settings,
                  'route': '/pengaturan'
                },
                {
                  'name': 'Tentang SoloGather',
                  'icon': Icons.event,
                  'route': '/tentang'
                },
                {
                  'name': 'Kritik & Saran',
                  'icon': Icons.feedback,
                  'route': '/kritik'
                },
                {
                  'name': 'Logout',
                  'icon': Icons.logout_rounded,
                  'route': '/logout'
                },
              ]
            : [
                {'name': 'Login', 'icon': Icons.login, 'route': '/login'},
                {
                  'name': 'Favoritku',
                  'icon': Icons.favorite,
                  'route': '/favoritku'
                },
                {
                  'name': 'Pengaturan',
                  'icon': Icons.settings,
                  'route': '/pengaturan'
                },
                {
                  'name': 'Tentang SoloGather',
                  'icon': Icons.event,
                  'route': '/tentang'
                },
                {
                  'name': 'Kritik & Saran',
                  'icon': Icons.feedback,
                  'route': '/kritik'
                },
              ];
              if (email == 'admin@sg.com') {
                menu.add({'name': 'Add Events', 'icon': Icons.event_available_rounded, 'route': '/addEvents'});
                menu.add({'name': 'Add Wisata', 'icon': Icons.location_city_rounded, 'route': '/addWisata'});
              }
      });
    });
  }

  void logout() async {
    await _auth.signOut();
    // Use Navigator.popAndPushNamed to refresh the Profil screen
    Navigator.popAndPushNamed(context, '/profil');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil dan Lainnya',
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
            height: statusLogin ? 535 : 360,
            color: Colors.white,
            child: Column(
              children: [
                statusLogin
                    ? Container(
                        padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_1280.png'),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 15, left: 8),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5, left: 8),
                                  child: Text(
                                    email,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    : Container(),
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
