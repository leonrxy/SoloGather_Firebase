import 'package:flutter/material.dart';
import 'package:sologather/get_data/get_events.dart';
//import 'package:sologather/widgets/shimmer.dart';
import 'package:intl/intl.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageDetailEvent extends StatefulWidget {
  const PageDetailEvent({super.key, required this.event});

  final Events event;

  @override
  State<PageDetailEvent> createState() => _PageDetailEventState();
}

class _PageDetailEventState extends State<PageDetailEvent> {
  List<Events> listEvent = [];
  bool isLoading = true;
  Repo repo = Repo();

  //GoogleMapController? _controller;

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
      List<Events> event = await repo.getData('events');

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
                        image: NetworkImage(widget.event.foto),
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
                            widget.event.nama,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.bookmark_add_outlined,
                          color: Colors.blue,
                          size: 30,
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
                          widget.event.biaya,
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
                              widget.event.tanggal,
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
                                '${formatTime(widget.event.jam_mulai)} - ${formatTime(widget.event.jam_selesai)}',
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
                            widget.event.tempat,
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
                Container(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 4, left: 15, right: 15),
                  child: Text(
                    widget.event.deskripsi,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   height: 200,
          //   child: GoogleMap(
          //     onMapCreated: (controller) {
          //       _controller = controller;
          //     },
          //     initialCameraPosition: CameraPosition(
          //       target: LatLng(widget.event.latitude, widget.event.longitude),
          //       zoom: 15,
          //     ),
          //     markers: {
          //       Marker(
          //         markerId: MarkerId('event_location'),
          //         position:
          //             LatLng(widget.event.latitude, widget.event.longitude),
          //       ),
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
