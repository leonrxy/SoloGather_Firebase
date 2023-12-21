import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Rating extends StatefulWidget {
  const Rating({Key? key, required this.rating});
  final double rating;
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  double rating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating Tempat Wisata'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 10),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 4, left: 15, right: 15),
                child: Text(
                  'Beri rating tempat wisata ini',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Sampaikan pendapat Anda tentang pengalaman Anda di tempat wisata ini!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: RatingBar.builder(
                  initialRating: widget.rating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 18.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.blue,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 400,
                  height: 90,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Deskripsikan pengalaman anda',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text(
                    'Kirim',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
