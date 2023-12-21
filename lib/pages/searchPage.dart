import 'package:flutter/material.dart';
import 'package:sologather/get_data/get_events_firebase.dart';
import 'package:sologather/get_data/get_wisata_firebase.dart';
import 'package:sologather/pages/detailEvent.dart';
import 'package:intl/intl.dart';
import 'package:sologather/pages/detailWisata.dart';

class SearchResultsPage extends StatefulWidget {
  final String search;

  SearchResultsPage({required this.search});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<Events> listEvent = [];
  List<DataWisata> listWisata = [];
  List<Events> searchResultsEvent = [];
  List<DataWisata> searchResultsWisata = [];
  bool isLoading = true;
  bool isSearch = false;

  Repo repo = Repo();
  RepoWisata repoWisata = RepoWisata();

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
      List<DataWisata> wisata = await repoWisata.getData();

      if (mounted) {
        // Pastikan widget masih ada sebelum memanggil setState
        setState(() {
          listEvent = event;
          listWisata = wisata;
          if (listEvent.length == 0) {
            isLoading = true;
          } else {
            isLoading = false;

            // Lakukan pencarian berdasarkan kata kunci
            searchResultsEvent = listEvent
                .where((event) => event.nama
                    .toLowerCase()
                    .contains(widget.search.toLowerCase()))
                .toList();

            searchResultsWisata = listWisata
                .where((wisata) => wisata.nama
                    .toLowerCase()
                    .contains(widget.search.toLowerCase()))
                .toList();
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

  String formatTime(String time) {
    // Parse the time string to DateTime
    DateTime parsedTime = DateTime.parse("2023-01-01 " + time);

    // Format the DateTime to the desired time format
    String formattedTime = DateFormat.Hm().format(parsedTime);

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Pencarian `${widget.search}`'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Event Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Tampilkan daftar hasil pencarian untuk event
          if (searchResultsEvent.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: searchResultsEvent.length,
              itemBuilder: (context, index) {
                Events event = searchResultsEvent[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PageDetailEvent(event: event),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: Container(
                      margin: EdgeInsets.all(2),
                      height: 110,
                      color: Colors.white,
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  event.foto,
                                  fit: BoxFit.fill,
                                  width: 140,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: Text(
                                      event.nama,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
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
                                          size: 17,
                                          color: Colors.blue[600],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          event.biaya,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
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
                                          size: 17,
                                          color: Colors.blue[600],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          event.tanggal,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
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
                                          size: 17,
                                          color: Colors.blue[600],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${formatTime(event.jam_mulai)} - ${formatTime(event.jam_selesai)}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 5, right: 8),
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'Selengkapnya...',
                                      style: TextStyle(
                                        color: Colors.blue[600],
                                        fontSize: 14,
                                      ),
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

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Wisata Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Tampilkan daftar hasil pencarian untuk wisata
          if (searchResultsWisata.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: searchResultsWisata.length,
              itemBuilder: (context, index) {
                DataWisata wisata = searchResultsWisata[index];
                return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PageDetailWisata(wisata: wisata),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child: Container(
                          margin: EdgeInsets.all(2),
                          height: 110,
                          color: Colors.white,
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      wisata.foto,
                                      fit: BoxFit.fill,
                                      width: 140,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 5, 10, 0),
                                        child: Text(
                                          wisata.nama,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
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
                                              size: 17,
                                              color: Colors.blue[600],
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              wisata.biaya,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13,
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
                                              size: 17,
                                              color: Colors.blue[600],
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              wisata.telp,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13,
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
                                              size: 17,
                                              color: Colors.blue[600],
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${formatTime(listWisata[index].jam_buka)} - ${formatTime(listWisata[index].jam_tutup)}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 8),
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          'Selengkapnya...',
                                          style: TextStyle(
                                            color: Colors.blue[600],
                                            fontSize: 14,
                                          ),
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

          // Tampilkan pesan jika tidak ada hasil pencarian
          if (searchResultsEvent.isEmpty && searchResultsWisata.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('No results found.'),
            ),
        ],
      ),
    );
  }
}
