import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WisataForm extends StatefulWidget {
  @override
  _WisataFormState createState() => _WisataFormState();
}

class _WisataFormState extends State<WisataForm> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController _jamBuka = TextEditingController();
  TextEditingController _jamTutup = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool clickButton = false;

  String errorMessage = '';

  String nama = '';
  String telp = '';
  String foto = '';
  String biaya = '';
  String jamBuka = '';
  String jamTutup = '';
  String tempat = '';
  String deskripsi = '';
  String gmaps = '';

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    dateinput.text = "";
  }

  startRegistration() async {
    try {
      // Simpan data acara ke Firestore
      await FirebaseFirestore.instance.collection('wisata').add({
        'nama': nama,
        'telp': telp,
        'foto': foto,
        'biaya': biaya,
        'jam_buka': _jamBuka.text,
        'jam_tutup': _jamTutup.text,
        'tempat': tempat,
        'deskripsi': deskripsi,
        'gmaps': gmaps,
      });

      // Pendaftaran berhasil
      setState(() {
        // Update UI jika diperlukan
      });

      Navigator.of(context).pop(true);

      // Navigasi ke layar yang diinginkan (misalnya, layar sukses)
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Pendaftaran gagal
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final formattedTime =
          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}:00";
      controller.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Wisata'),
        backgroundColor: Colors.blue[500],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'SoloGather - Add Wisata',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nama Tempat Wisata',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      nama = value;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'No Telepon',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      telp = value;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Link Foto Acara',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      foto = value;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Biaya',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      biaya = value;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: GestureDetector(
                    onTap: () => _selectTime(context, _jamBuka),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _jamBuka,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                        decoration: InputDecoration(
                          hintText: '00:00:00',
                          labelText: 'Jam Buka',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          jamBuka = value;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: GestureDetector(
                    onTap: () => _selectTime(context, _jamTutup),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _jamTutup,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                        decoration: InputDecoration(
                          hintText: '00:00:00',
                          labelText: 'Jam Tutup',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          jamTutup = value;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tempat',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      tempat = value;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      deskripsi = value;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Link Google Maps',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      gmaps = value;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[500],
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        startRegistration();
                      }
                      clickButton = true;
                    },
                    child: Text(
                      'Tambahkan Acara',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Kembali ke '),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          'Beranda',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
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
  }
}
