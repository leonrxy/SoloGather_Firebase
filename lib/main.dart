import 'package:flutter/material.dart';
import 'package:sologather/splashscreen.dart';
import 'package:sologather/pages/home.dart';
import 'package:sologather/pages/profil.dart';
import 'package:sologather/pages/event.dart';
import 'package:sologather/pages/wisata.dart';
import 'package:sologather/pages/berita.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _showSplash ? SplashScreenKu() : NavigationBar(),
      routes: {
        '/home': (context) => NavigationBar(),
        '/splash': (context) => SplashScreenKu(),
      },
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Home(),
      PageEvent(),
      Wisata(),
      Berita(),
      Profil(),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Wisata',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Berita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
        type: BottomNavigationBarType.fixed, // addded line
      ),
    );
  }
}
