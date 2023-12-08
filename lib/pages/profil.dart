import 'package:flutter/material.dart';

class Profil extends StatelessWidget {
  Profil({Key? key});

  final List<Map<String, dynamic>> menu = [
    {'name': 'Login', 'icon': Icons.person_2_outlined, 'route': '/login'},
    {
      'name': 'Favoritku',
      'icon': Icons.favorite_border_outlined,
      'route': '/favoritku'
    },
    {'name': 'Pengaturan', 'icon': Icons.settings, 'route': '/pengaturan'},
    {'name': 'Tentang SoloGather', 'icon': Icons.event, 'route': '/tentang'},
    {'name': 'Kritik & Saran', 'icon': Icons.feedback, 'route': '/kritik'},
  ];

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
            height: 360,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: List.generate(menu.length, (index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 150),
                                  () {
                                Navigator.pushNamed(
                                  context,
                                  menu[index]['route'],
                                );
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(
                                  top: BorderSide(color: Colors.grey[300]!),
                                  bottom: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 8, right: 8),
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
                    }),
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
