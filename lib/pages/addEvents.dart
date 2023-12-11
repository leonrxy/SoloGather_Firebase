import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsForm extends StatefulWidget {
  @override
  _EventsFormState createState() => _EventsFormState();
}

class _EventsFormState extends State<EventsForm> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController _jamMulai = TextEditingController();
  TextEditingController _jamSelesai = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool clickButton = false;

  String errorMessage = '';

  String nama = '';
  String foto = '';
  String biaya = '';
  String tanggal = '';
  String jamMulai = '';
  String jamSelesai = '';
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
      await FirebaseFirestore.instance.collection('events').add({
        'nama': nama,
        'foto': foto,
        'biaya': biaya,
        'tanggal': dateinput.text,
        'jam_mulai': _jamMulai.text,
        'jam_selesai': _jamSelesai.text,
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
        title: Text('Add Events'),
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
                    'SoloGather - Add Events',
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
                      labelText: 'Nama Acara',
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
                  child: TextFormField(
                    controller: dateinput,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tanggal Acara',
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        print(pickedDate);
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate);

                        setState(() {
                          dateinput.text = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: GestureDetector(
                    onTap: () => _selectTime(context, _jamMulai),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _jamMulai,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                        decoration: InputDecoration(
                          hintText: '00:00:00',
                          labelText: 'Jam Mulai',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          jamMulai = value;
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
                    onTap: () => _selectTime(context, _jamSelesai),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _jamSelesai,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                        decoration: InputDecoration(
                          hintText: '00:00:00',
                          labelText: 'Jam Selesai',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          jamSelesai = value;
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
