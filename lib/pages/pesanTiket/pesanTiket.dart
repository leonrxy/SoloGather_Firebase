import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sologather/get_data/get_events_firebase.dart';
import 'package:sologather/pages/pesanTiket/detailTiket.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:input_quantity/input_quantity.dart';

class PesanTiket extends StatefulWidget {
  const PesanTiket({super.key, required this.event});

  final Events event;

  @override
  State<PesanTiket> createState() => _PesanTiketState();
}

class _PesanTiketState extends State<PesanTiket> {
  List<Events> listEvent = [];
  bool isLoading = true;
  Repo repo = Repo();
  late SharedPreferences prefs;
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  int jmlTiket = 1;

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
            'Detail Pesanan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          leading: BackButton(
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        backgroundColor: Colors.grey[200],
        body: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 7),
              height: 300,
              child: SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 4)),
                    DateTime.now().add(const Duration(days: 3))),
                minDate: DateTime.now(),
                initialSelectedDate: DateTime.now(),
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      'Jumlah Tiket',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Orang',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20),
                        child: InputQty(
                          decoration: const QtyDecorationProps(
                            isBordered: false,
                            minusBtn: Icon(
                              Icons.remove_circle_rounded,
                              color: Colors.blue,
                            ),
                            plusBtn: Icon(Icons.add_circle_rounded,
                                color: Colors.blue),
                          ),
                          maxVal: 100,
                          initVal: 1,
                          minVal: 1,
                          steps: 1,
                          onQtyChanged: (val) {
                            setState(() {
                              jmlTiket = val.toInt();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'IDR ' +
                          formatCurrency((int.parse(widget.event.biaya)) *
                              jmlTiket.toInt()),
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin:
                    EdgeInsets.only(top: 10, bottom: 20, left: 15, right: 15),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTiket(
                            event: widget.event,
                            date: _selectedDate,
                            jmlTiket: jmlTiket.toInt()),
                      ),
                    );
                  },
                  child: Text(
                    'Pesan',
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
            ),
          ],
        ),
      ),
    );
  }
}
