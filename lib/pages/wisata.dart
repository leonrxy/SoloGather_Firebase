import 'package:flutter/material.dart';
import 'package:sologather/get_data/get_wisata_firebase.dart';
import 'package:sologather/pages/detailWisata.dart';
import 'package:sologather/widgets/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Wisata extends StatefulWidget {
  const Wisata({Key? key}) : super(key: key);

  @override
  State<Wisata> createState() => _WisataState();
}

class _WisataState extends State<Wisata> {
  final db = FirebaseFirestore.instance;
  List<DataWisata> listWisata = [];
  bool isLoading = true;
  RepoWisata repo = RepoWisata();

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
      List<DataWisata> wisata = await repo.getData();

      if (mounted) {
        setState(() {
          listWisata = wisata;
          print("WIsata: $listWisata[1]");
          isLoading = false;
        });
      }
      print(listWisata);
      print(isLoading);
    } catch (e) {
      print('Error occurred while fetching data wisata: $e');
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Wisata',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey[200],
        body: isLoading
            ? AppShimmer(width: 500, height: 200)
            : Container(
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listWisata.length,
                  itemBuilder: (context, index) {
                    DataWisata data = listWisata[index];
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
              ));
  }
}
