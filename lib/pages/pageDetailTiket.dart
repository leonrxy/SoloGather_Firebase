import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sologather/get_data/get_events_firebase.dart';
import 'package:sologather/pages/pesanTiket/pesanTiketSukses.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class PageDetailTiket extends StatefulWidget {
  const PageDetailTiket({Key? key}) : super(key: key);

  @override
  State<PageDetailTiket> createState() => _PageDetailTiketState();
}

class _PageDetailTiketState extends State<PageDetailTiket> {
  List<Events> listEvent = [];
  bool isLoading = true;
  Repo repo = Repo();
  late SharedPreferences prefs;
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String email = '';
  String name = '';

  void initState() {
    super.initState();
    init();
    getProfil();
  }

  Future<void> init() async {
    await getData();
  }

  Future<void> getData() async {
    try {
      List<Events> event = await repo.getData();

      if (mounted) {
        setState(() {
          listEvent = event;
          isLoading = listEvent.isEmpty;
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
    DateTime parsedTime = DateTime.parse("2023-01-01 " + time);
    String formattedTime = DateFormat.Hm().format(parsedTime);
    return formattedTime;
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat("#,###");
    return formatter.format(amount);
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            '${DateFormat('dd MMM yyyy', 'id').format(args.value.startDate)} -'
            ' ${DateFormat('dd MMM yyyy', 'id').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = DateFormat('dd MMM yyyy', 'id').format(args.value);
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  Future<void> getProfil() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('userEmail') ?? '';
    print('Email: $email');
    name = prefs.getString('userName') ?? '';
    print('Name: $name');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Tiket Saya"),
        ),
        backgroundColor: Colors.grey[200],
        body: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/header.jpg',
                      width: 400,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                    height: 350,
                    child: ListView(
                      children: [
                        if (listEvent.isNotEmpty)
                          Container(
                            child: Row(
                              children: [
                                // Container(
                                //   child: ClipRRect(
                                //     borderRadius: BorderRadius.circular(8),
                                //     child: Image.network(
                                //       listEvent[0].foto, // Adjust as needed
                                //       fit: BoxFit.fill,
                                //       width: 60,
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: Text(
                                      listEvent[0].nama, // Adjust as needed
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Divider(
                          color: Colors.grey,
                          height: 20,
                          thickness: 1,
                        ),
                        Container(
                          padding: EdgeInsets.only(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Adjust the alignment as needed
                            children: [
                              Text(
                                'Lokasi',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Lokasi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Adjust the alignment as needed
                            children: [
                              Text(
                                'Tanggal Dipilih',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Tanggal Dipilih',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Adjust the alignment as needed
                            children: [
                              Text(
                                'ID Tiket',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'ID',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 20,
                          thickness: 1,
                        ),
                        Container(
                          padding: EdgeInsets.only(),
                          child: Text(
                            'Nama',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600]),
                          ),
                        ),
                        Text(
                          'Nama',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          padding: EdgeInsets.only(),
                          child: Text(
                            'Harga',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600]),
                          ),
                        ),
                        Text(
                          'Harga',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}