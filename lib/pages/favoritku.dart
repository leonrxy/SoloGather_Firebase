import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sologather/get_data/get_events_firebase.dart';
import 'package:sologather/get_data/get_wisata_firebase.dart';
import 'package:sologather/pages/detailEvent.dart';
import 'package:sologather/pages/detailWisata.dart';

class Favoritku extends StatefulWidget {
  const Favoritku({Key? key}) : super(key: key);

  @override
  _FavoritkuState createState() => _FavoritkuState();
}

class _FavoritkuState extends State<Favoritku> {
  List<Events> favoriteEvents = [];
  List<DataWisata> favoriteWisata = [];

  @override
  void initState() {
    super.initState();
    _getFavoriteEvents();
    _getFavoriteWisata();
  }

  Future<void> _getFavoriteEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteEventIds = prefs.getKeys().toList();

    List<Events> events = await getEventsFromIds(favoriteEventIds);

    setState(() {
      favoriteEvents = events;
    });
  }

  Future<void> _getFavoriteWisata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteWisataIds = prefs.getKeys().toList();

    List<DataWisata> wisata = await getWisataFromIds(favoriteWisataIds);

    setState(() {
      favoriteWisata = wisata;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Favoritku',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            favoriteEvents.isEmpty && favoriteWisata.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.favorite_outline_outlined,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        Text(
                          'Belum Ada Favorit',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Tambahkan favorite dengan mengklik ikon favorit di masing-masing event',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : Container(),
            favoriteEvents.isEmpty
                ? Container()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: favoriteEvents.length,
                    itemBuilder: (context, index) {
                      Events data = favoriteEvents[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PageDetailEvent(event: data),
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
                                        favoriteEvents[index].foto,
                                        fit: BoxFit.fill,
                                        width: 140,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(10, 5, 10, 0),
                                          child: Text(
                                            favoriteEvents[index].nama,
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
                                                favoriteEvents[index].biaya,
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
                                                favoriteEvents[index].tanggal,
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
                                                favoriteEvents[index].jam_mulai,
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
                                              left: 5, right: 8),
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
            favoriteWisata.isEmpty
                ? Container()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: favoriteWisata.length,
                    itemBuilder: (context, index) {
                      DataWisata data = favoriteWisata[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PageDetailWisata(wisata: data),
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
                                        data.foto,
                                        fit: BoxFit.fill,
                                        width: 140,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(10, 5, 10, 0),
                                          child: Text(
                                            data.nama,
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
                                                data.biaya,
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
                                                data.telp,
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
                                                data.jam_buka,
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
                                              left: 5, right: 8),
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
          ],
        ));
  }
}

// This function fetches events based on their IDs
Future<List<Events>> getEventsFromIds(List<String> eventIds) async {
  Repo repo = Repo();
  List<Events> events =
      await repo.getData(); // Assuming getData fetches all events
  return events
      .where((event) => eventIds.contains(event.id.toString()))
      .toList();
}

Future<List<DataWisata>> getWisataFromIds(List<String> wisataIds) async {
  RepoWisata repo = RepoWisata();
  List<DataWisata> wisata =
      await repo.getData(); // Assuming getData fetches all wisata
  return wisata
      .where((wisata) => wisataIds.contains(wisata.id.toString()))
      .toList();
}
