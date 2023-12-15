import 'package:flutter/material.dart';

class PageAdmin extends StatefulWidget {
  const PageAdmin({super.key});

  @override
  State<PageAdmin> createState() => _PageAdminState();
}

class _PageAdminState extends State<PageAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}