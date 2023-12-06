import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:sologather/get_data/get_events.dart';
import 'package:sologather/get_data/get_banner.dart';
import 'package:sologather/pages/detailEvent.dart';
import 'package:sologather/widgets/shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class Home extends StatefulWidget {
  final VoidCallback goPageEvent;

  Home({required this.goPageEvent});
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Events> listEvent = [];
  List<AppBanner> listBanner = [];
  bool isLoading = true;
  bool isSearch = false;

  Repo repo = Repo();
  RepoBanner repoBanner = RepoBanner();

  Widget appLogo = Container(
    padding: const EdgeInsets.all(4.0),
    child: Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.contain,
      height: 32,
    ),
  );
  Widget SearchBar = Icon(
    Icons.search_rounded,
    color: Colors.orange,
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getData();
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<Events> event = await repo.getData('events');
      List<AppBanner> banner = await repoBanner.getData();
      if (mounted) {
        // Pastikan widget masih ada sebelum memanggil setState
        setState(() {
          listEvent = event;
          listBanner = banner;
          if (listEvent.length == 0) {
            isLoading = true;
          } else {
            isLoading = false;
          }
        });
      }
    } catch (e) {
      print('Error occurred while fetching data: $e');
      setState(() {
        isLoading = true;
      });
    }
  }

  final List<Map<String, dynamic>> categories = [
    {'name': 'Peta Wisata', 'icon': Icons.maps_home_work},
    {'name': 'Destinasi', 'icon': Icons.location_city},
    {'name': 'Informasi', 'icon': Icons.info},
    {'name': 'Event', 'icon': Icons.event},
    {'name': 'Kritik & Saran', 'icon': Icons.feedback},
  ];

  @override
  Widget build(BuildContext context) {
    List<Future<void>> precacheFutures = List.generate(
      listBanner.length,
      (index) => precacheImage(NetworkImage(listBanner[index].foto), context),
    );
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              isSearch = !isSearch;
              setState(() {
                if (isSearch) {
                  SearchBar = Icon(
                    Icons.cancel,
                    color: Colors.orange,
                  );
                  appLogo = ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.orange,
                      size: 28,
                    ),
                    title: TextField(
                      onChanged: (query) {},
                      decoration: InputDecoration(
                        hintText: 'Cari Event',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Color.fromARGB(255, 19, 0, 0),
                      ),
                    ),
                  );
                } else {
                  SearchBar = Icon(
                    Icons.search_rounded,
                    color: Colors.orange,
                  );
                  appLogo = Container(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      height: 32,
                    ),
                  );
                }
              });
            },
            icon: SearchBar,
          )
        ],
        title: appLogo,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: ListView(
        padding: const EdgeInsets.all(4),
        children: <Widget>[
          (isLoading || listBanner.length == 0)
              ? AppShimmer(width: 140, height: 200)
              : Container(
                  padding: const EdgeInsets.all(10),
                  height: 150,
                  color: Colors.grey[100],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: listBanner.isNotEmpty
                        ? ImageSlideshow(
                            width: double.infinity,
                            height: 150,
                            initialPage: 0,
                            indicatorColor: Colors.blue,
                            indicatorBackgroundColor:
                                const Color.fromRGBO(158, 158, 158, 1),
                            children: List.generate(listBanner.length, (index) {
                              return Image.network(
                                listBanner[index].foto,
                                fit: BoxFit.fill,
                              );
                            }),
                            onPageChanged: (value) {
                              print('Page changed: $value');
                            },
                            autoPlayInterval: 4000,
                            isLoop: true,
                          )
                        : Container(),
                  ),
                ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 8.0, // Jarak antar item
                  runSpacing: 8.0, // Jarak antar baris
                  children: List.generate(categories.length, (index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Material(
                            elevation: 4,
                            //shape: CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            color: Colors.transparent,
                            child: Container(
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                //shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: Icon(categories[index]['icon'], size: 30),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(categories[index]['name'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 4, top: 0, left: 8),
                //height: 50,
                color: Colors.transparent,
                child: const Text(
                  'Event Terkini',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: widget.goPageEvent,
                  child: Text(
                    'Lihat Semua',
                    style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 200,
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 10),
            child: (isLoading || listEvent.length == 0)
                ? AppShimmer(width: 140, height: 200)
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: min(listEvent.length, 7),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PageDetailEvent(event: listEvent[index]),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4),
                          width: 140,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Container(
                                    height: 120,
                                    margin: EdgeInsets.only(bottom: 3),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(listEvent[index].foto),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 4, right: 4),
                                    child: Text(
                                      listEvent[index].nama,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, top: 2),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.monetization_on_outlined,
                                          size: 16,
                                          color: Colors.blue[600],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          listEvent[index].biaya,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, top: 2),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.date_range_outlined,
                                          size: 16,
                                          color: Colors.blue[600],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          listEvent[index].tanggal,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, top: 2),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.access_time_outlined,
                                          size: 16,
                                          color: Colors.blue[600],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          listEvent[index].jam_mulai,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 4, top: 0, left: 8),
                //height: 50,
                color: Colors.transparent,
                child: const Text(
                  'Rekomendasi Untuk Anda',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(right: 8),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Lihat Semua',
                      style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ))
            ],
          ),
        ],
      ),
    ));
  }
}
