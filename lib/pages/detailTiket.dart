import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sologather/get_data/get_events_firebase.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:input_quantity/input_quantity.dart';

class DetailTiket extends StatefulWidget {
  const DetailTiket(
      {super.key,
      required this.event,
      required this.date,
      required this.jmlTiket});

  final Events event;
  final int jmlTiket;
  final String date;

  @override
  State<DetailTiket> createState() => _DetailTiketState();
}

class _DetailTiketState extends State<DetailTiket> {
  List<Events> listEvent = [];
  bool isLoading = true;
  Repo repo = Repo();
  late SharedPreferences prefs;
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  void initState() {
    super.initState();
    init();
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

  String formatTime(String time) {
    // Parse the time string to DateTime
    DateTime parsedTime = DateTime.parse("2023-01-01 " + time);

    // Format the DateTime to the desired time format
    String formattedTime = DateFormat.Hm().format(parsedTime);

    return formattedTime;
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            '${DateFormat('dd MMM yyyy', 'id').format(args.value.startDate)} -'
            ' ${DateFormat('dd MMM yyyy', 'id').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        // Format the date using intl package
        _selectedDate = DateFormat('dd MMM yyyy', 'id').format(args.value);
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Selesaikan Pesananmu',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          leading: BackButton(color: Colors.black),
        ),
        backgroundColor: Colors.grey[200],
        body: ListView(
          children: <Widget>[
            Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                height: 300,
                child: ListView(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.event.foto,
                                fit: BoxFit.fill,
                                width: 60,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: Text(
                                widget.event.nama,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(),
                      child: Column(
                        children: [
                          Text(
                            'Jumlah Tiket',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.jmlTiket.toString() + " Tiket",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      padding: EdgeInsets.only(),
                      child: Text(
                        'Tanggal Dipilih',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600]),
                      ),
                    ),
                    Text(
                      widget.date,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Detail Pemesanan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      child: Column(
                    children: [
                      Text(
                        'Nama',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  //padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'IDR ' + widget.event.biaya,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'Lanjutkan Pembayaran',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
