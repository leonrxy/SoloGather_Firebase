import 'package:flutter/material.dart';

class Profil extends StatelessWidget {
  Profil({Key? key});

  final List<Map<String, dynamic>> menu = [
    {'name': 'Login', 'icon': Icons.person_2_outlined},
    {'name': 'Favoritku', 'icon': Icons.favorite_border_outlined},
    {'name': 'Pengaturan', 'icon': Icons.settings},
    {'name': 'Tentang SoloGather', 'icon': Icons.event},
    {'name': 'Kritik & Saran', 'icon': Icons.feedback},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil dan Lainnya',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(color: Colors.grey[300]!),
                              bottom: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          padding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 8, right: 8),
                          child: InkWell(
                            onTap: () {
                              // Handle menu item click
                              print(
                                  'Menu Item Clicked: ${menu[index]['name']}');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
