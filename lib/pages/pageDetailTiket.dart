import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sologather/get_data/get_tiket.dart';
import 'package:sologather/pages/pesanTiket/pesanTiket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageDetailTiket extends StatefulWidget {
  const PageDetailTiket({super.key, required this.tiket});

  final DataTiket tiket;

  @override
  State<PageDetailTiket> createState() => _PageDetailTiketState();
}

class _PageDetailTiketState extends State<PageDetailTiket> {
  List<DataTiket> listTiket = [];
  bool isLoading = true;
  RepoTiket repo = RepoTiket();

  late SharedPreferences _prefs;

  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getData();
  }

  Future<void> getData() async {
    try {
      String userEmail =
          'email_pengguna@contoh.com'; // Ganti dengan email pengguna sebenarnya
      List<DataTiket> tiket = await repo.getData(userEmail);

      if (mounted) {
        setState(() {
          listTiket = tiket;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error occurred while fetching booking data: $e');
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
      backgroundColor: Colors.grey[200],
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 320,
                    margin: EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.tiket.email),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 4, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.tiket.nama,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border_outlined,
                            color: Colors.blue,
                            size: 30,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.monetization_on_outlined,
                          size: 20,
                          color: Colors.blue[600],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.tiket.harga,
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
                        EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              size: 20,
                              color: Colors.blue[600],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.tiket.tanggal,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 12, right: 12, top: 2, bottom: 2),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.access_time_outlined,
                                size: 20,
                                color: Colors.blue[600],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${formatTime(widget.tiket.jam_mulai)} - ${formatTime(widget.tiket.jam_selesai)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: Colors.blue[600],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            widget.tiket.tempat,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                            maxLines: 2,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 4, left: 15, right: 15),
                  child: Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
