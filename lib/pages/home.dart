import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:sologather/get_data/get_events_firebase.dart';
import 'package:sologather/get_data/get_banner.dart';
import 'package:sologather/get_data/get_wisata_firebase.dart';
import 'package:sologather/pages/detailEvent.dart';
import 'package:sologather/pages/detailWisata.dart';
import 'package:sologather/pages/searchPage.dart';
import 'package:sologather/widgets/shimmer.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  final VoidCallback goPageEvent;
  final VoidCallback goPageWisata;

  Home({required this.goPageEvent, required this.goPageWisata});
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Events> listEvent = [];
  List<DataWisata> listWisata = [];
  List<AppBanner> listBanner = [];
  bool isLoading = true;
  bool isSearch = false;

  Repo repo = Repo();
  RepoBanner repoBanner = RepoBanner();
  RepoWisata repoWisata = RepoWisata();

  TextEditingController searchController = TextEditingController();

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
    color: Colors.blue,
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
      List<Events> event = await repo.getData();
      List<AppBanner> banner = await repoBanner.getData();
      List<DataWisata> wisata = await repoWisata.getData();
      List<Events> filteredEvents = listEvent
          .where((event) => event.nama
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();

      if (mounted) {
        // Pastikan widget masih ada sebelum memanggil setState
        setState(() {
          listEvent = event;
          listBanner = banner;
          listWisata = wisata;
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
    {'name': 'Peta Wisata', 'icon': Icons.maps_home_work, 'route': '/peta'},
    {'name': 'Destinasi', 'icon': Icons.location_city, 'route': '/wisata'},
    {'name': 'Informasi', 'icon': Icons.info, 'route': '/informasi'},
    {'name': 'Kritik & Saran', 'icon': Icons.feedback, 'route': '/kritik'},
  ];

  String formatTime(String time) {
    // Parse the time string to DateTime
    DateTime parsedTime = DateTime.parse("2023-01-01 " + time);

    // Format the DateTime to the desired time format
    String formattedTime = DateFormat.Hm().format(parsedTime);

    return formattedTime;
  }

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
                    color: Colors.blue,
                  );
                  appLogo = ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.blue,
                      size: 28,
                    ),
                    title: TextField(
                      controller: searchController,
                      onEditingComplete: () {
                        // Handle onEditingComplete event
                        // Navigasi ke halaman pencarian hasil dengan membawa data hasil pencarian
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultsPage(
                                search: searchController.text),
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari Event dan Wisata',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
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
                    color: Colors.blue,
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
                              AppBanner data = listBanner[index];
                              return Image.network(
                                data.foto,
                                fit: BoxFit.fill,
                              );
                            }),
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
                    return Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Future.delayed(
                                    const Duration(milliseconds: 150), () {
                                  Navigator.pushNamed(
                                    context,
                                    categories[index]['route'],
                                  );
                                });
                              },
                              child: ClipRRect(
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
                                    child: Icon(categories[index]['icon'],
                                        size: 30),
                                  ),
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
                        ));
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
                      Events dataEvent = listEvent[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PageDetailEvent(event: dataEvent),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4),
                          width: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Container(
                                    height: 110,
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
                                      textAlign: TextAlign.left,
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
                                        left: 5, right: 5, top: 2, bottom: 5),
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
                                          '${formatTime(listEvent[index].jam_mulai)} - ${formatTime(listEvent[index].jam_selesai)}',
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
                  'Rekomendasi Wisata',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: widget.goPageWisata,
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
            child: (isLoading || listWisata.length == 0)
                ? AppShimmer(width: 140, height: 200)
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: min(listWisata.length, 7),
                    itemBuilder: (BuildContext context, int index) {
                      DataWisata dataWisata = listWisata[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PageDetailWisata(wisata: dataWisata),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4),
                          width: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Container(
                                    height: 110,
                                    margin: EdgeInsets.only(bottom: 3),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            listWisata[index].foto),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 4, right: 4),
                                    child: Text(
                                      listWisata[index].nama,
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
                                          listWisata[index].biaya,
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
                                          listWisata[index].jam_buka,
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
                                        left: 5, right: 5, top: 2, bottom: 5),
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
                                          '${formatTime(listWisata[index].jam_buka)} - ${formatTime(listWisata[index].jam_tutup)}',
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
        ],
      ),
    ));
  }
}
