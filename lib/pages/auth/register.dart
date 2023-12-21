import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController dateinput = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  bool clickButton = false;

  String errorMessage = '';

  String email = '';
  String password = '';
  String name = '';
  String no_hp = '';

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
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'birthdate': dateinput.text,
        'no_hp': no_hp,
        'alamat': '-',
        'photo': '-',
      });

      // Registration successful
      setState(() {
        // Update the UI as needed
      });

      // Navigate to the desired screen (e.g., home screen)
      Navigator.pushReplacementNamed(context, '/verifEmail');
    } on FirebaseAuthException catch (e) {
      // Registration failed
      setState(() {
        errorMessage = e.message!;
        print(e.code);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'SoloGather',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 400,
                  alignment: Alignment.center,
                  child: Text(
                    'Daftar SoloGather untuk menggunakan layanan-layanan dari SoloGather',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty && clickButton) {
                        return 'Email harus diisi';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'No. HP',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty && clickButton) {
                        return 'No. HP harus diisi';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      no_hp = value;
                    },
                    keyboardType: TextInputType.phone,
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
                      labelText: 'Tanggal Lahir',
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
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: _toggle,
                      ),
                    ),
                    obscureText: _obscureText,
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty && clickButton) {
                        return 'Password harus diisi';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: _toggle,
                      ),
                    ),
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value!.isEmpty && clickButton) {
                        return 'Konfirmasi password harus diisi';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  padding: EdgeInsets.all(10),
                  child: errorMessage.isNotEmpty
                      ? errmsg(errorMessage)
                      : SizedBox(height: 30),
                ),
                Container(
                  width: 400,
                  height: 38,
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
                      'Daftar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sudah memiliki akun SoloGather?'),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          'Masuk Disini',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
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
  }
}

Widget errmsg(String text) {
  //error message widget.
  return Container(
    padding: EdgeInsets.all(7.00),
    margin: EdgeInsets.only(bottom: 4.00),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
      border: Border.all(color: Colors.red, width: 2),
    ),
    child: Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 6.00),
          child: Icon(Icons.error, color: Colors.white),
        ),
        Text(text, style: TextStyle(color: Colors.white, fontSize: 13)),
      ],
    ),
  );
}

class VerifEmail extends StatefulWidget {
  @override
  State<VerifEmail> createState() => _VerifEmailState();
}

class _VerifEmailState extends State<VerifEmail> {
  bool isEmailVerified = false;
  Timer? timer;
  int timerCount = 0;
  bool isButtonLoading = false;
  int countdown = 30;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // TODO: Implement your code after email verification
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));

      // Navigate to the desired screen after successful login
      Navigator.pushReplacementNamed(context, '/home');

      timer?.cancel();
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      setState(() {
        isButtonLoading = true;
        countdown = 30;
      });

      countdownTimer = Timer.periodic(Duration(seconds: 2), (timer) {
        if (countdown > 0) {
          setState(() {
            countdown--;
          });
        } else {
          countdownTimer?.cancel();
          setState(() {
            isButtonLoading = false;
            
          });
        }
      });
      if(countdown <= 0){
        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      }

      // Simulate a delay for demonstration purposes
      await Future.delayed(Duration(seconds: 30));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification Email Resent")),
      );

      setState(() {
        isButtonLoading = false;
      });
    } catch (e) {
      countdownTimer?.cancel();
      setState(() {
        isButtonLoading = false;
      });
      debugPrint('$e');
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Login',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 25),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Verifikasi Email',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: 400,
                    alignment: Alignment.center,
                    child: Text(
                      'Kami telah mengirimkan email verifikasi ke alamat email Anda. Silakan periksa kotak masuk Anda dan klik tautan di dalamnya untuk memverifikasi akun Anda.',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 25),
                  if (isButtonLoading)
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    )
                  else
                    Container(),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: isButtonLoading
                              ? null
                              : () async => await resendVerificationEmail(),
                          child: Text(
                            'Kirim ulang email verifikasi',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[500],
                            ),
                          ),
                        ),
                        if (isButtonLoading) SizedBox(width: 8),
                        if (isButtonLoading)
                          Text(
                            '($countdown)',
                            style: TextStyle(fontSize: 14),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterSuccess extends StatelessWidget {
  const RegisterSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register Success',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Register Success',
              style: TextStyle(fontSize: 30),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'Go to Login',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
