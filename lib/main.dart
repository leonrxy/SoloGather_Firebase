import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sologather/get_data/loginSession.dart';
import 'package:sologather/pages/addWisata.dart';
import 'package:sologather/pages/informasi.dart';
import 'package:sologather/pages/kritiksaran.dart';
import 'package:sologather/pages/logout.dart';
import 'package:sologather/pages/pengaturan.dart';
import 'package:sologather/pages/petaWisata.dart';
import 'package:sologather/pages/tentang.dart';
import 'package:sologather/splashscreen.dart';
import 'package:sologather/pages/home.dart';
import 'package:sologather/pages/profil.dart';
import 'package:sologather/pages/event.dart';
import 'package:sologather/pages/wisata.dart';
import 'package:sologather/pages/berita.dart';
import 'package:sologather/pages/login.dart';
import 'package:sologather/pages/register.dart';
import 'package:sologather/pages/favoritku.dart';
import 'package:sologather/pages/addEvents.dart';
import 'package:sologather/pages/profilku.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => LoginSession(),
      child: MyApp(),
    ),
  );
}

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
        '/profil': (context) => Profil(),
        '/event': (context) => PageEvent(),
        '/wisata': (context) => Wisata(),
        '/berita': (context) => Berita(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/register2': (context) => RegisterSuccess(),
        '/favoritku': (context) => Favoritku(),
        '/pengaturan': (context) => Pengaturan(),
        '/tentang': (context) => Tentang(),
        '/kritik': (context) => KritikSaran(),
        '/informasi': (context) => Informasi(),
        '/peta': (context) => PetaWisata(),
        '/logout': (context) => Logout(),
        '/addEvents': (context) => EventsForm(),
        '/addWisata': (context) => WisataForm(),
        '/profilku': (context) => Profilku(),
      },
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeNavigationIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Home(
        goPageEvent: () {
          setState(() {
            _selectedIndex = 1;
          });
        },
        goPageWisata: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      PageEvent(),
      Wisata(),
      Profil(),
    ];

    return Scaffold(
      body: IndexedStack(
        //controller: _tabController,
        children: _widgetOptions,
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available_rounded),
            label: 'Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city_rounded),
            label: 'Wisata',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        type: BottomNavigationBarType.fixed, // addded line
      ),
    );
  }
}
