import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sologather/get_data/loginSession.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sologather/pages/addWisata.dart';
import 'package:sologather/pages/admin/admin.dart';
import 'package:sologather/pages/informasi.dart';
import 'package:sologather/pages/kritiksaran.dart';
import 'package:sologather/pages/logout.dart';
import 'package:sologather/pages/pengaturan.dart';
import 'package:sologather/pages/pesanTiket.dart';
import 'package:sologather/pages/petaWisata.dart';
import 'package:sologather/pages/tentang.dart';
import 'package:sologather/splashscreen.dart';
import 'package:sologather/pages/home.dart';
import 'package:sologather/pages/profil.dart';
import 'package:sologather/pages/event.dart';
import 'package:sologather/pages/wisata.dart';
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
        '/pesanTiket': (context) => PesanTiket(),
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
  String email = '';
  String name = '';
  bool statusLogin = false;
  List<Widget> _widgetOptions = <Widget>[];
  List<BottomNavigationBarItem> _bottomNavBarItems =
      <BottomNavigationBarItem>[];

  @override
  void initState() {
    super.initState();
    setNavbar();
  }

  Future<void> getProfil() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('userEmail') ?? '';
    print('Email' + email);
    name = (await LoginSession.getNameFromEmail(email)) ?? '';
    print('Name' + name);
  }

  setNavbar() {
    getProfil();
    _widgetOptions = <Widget>[
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

    _bottomNavBarItems = <BottomNavigationBarItem>[
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
    ];

    if (email == 'admin@sg.com') {
      print('LOGIN SEBAGAI ADMIN');
      _widgetOptions.add(PageAdmin());
      _bottomNavBarItems.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings_rounded),
          label: 'Admin',
        ),
      );
    }
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
    return Scaffold(
      body: IndexedStack(
        //controller: _tabController,
        children: _widgetOptions,
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavBarItems,
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
