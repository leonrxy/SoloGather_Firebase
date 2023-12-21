import 'package:flutter/material.dart';

class TiketSaya extends StatefulWidget {
  const TiketSaya({super.key});

  @override
  State<TiketSaya> createState() => _TiketSayaState();
}

class _TiketSayaState extends State<TiketSaya> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Tiket Saya"),
        ),
        body: Center(
          child: Text("Tiket Saya"),
        ),
      ),
    );
  }
}