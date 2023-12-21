import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String errormsg = '';
  //var statuslogin = false;
  late SharedPreferences prefs;

  bool error = false;
  bool showprogress = false;
  bool statusLogin = false;

  String email = '';
  String password = '';

  var _email = TextEditingController();

  var _password = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    email = "";
    password = "";
    errormsg = "";
    error = false;
    showprogress = false;
    initPrefs().then((_) {
      readLoginStatus();
    });
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Save login status
  Future<void> saveLoginStatus(User user) async {
    prefs.setBool('isLogin', true);
    print('Email : ' + user.email!);
    print('UID : ' + user.uid);
    prefs.setString('userUid', user.uid);
    prefs.setString('userEmail', user.email!);
    String name = await getNameFromEmail(email) ?? '';
    prefs.setString('userName', name);

    //prefs.setString('userDisplayName', user.displayName!);
  }

  Future<String?> getNameFromEmail(String email) async {
  try {
    // Mendapatkan referensi koleksi 'users' di Firestore
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Membuat kueri untuk mencari dokumen dengan email yang sesuai
    QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();

    // Memeriksa apakah dokumen ditemukan
    if (querySnapshot.docs.isNotEmpty) {
      // Mengambil data nama dari dokumen pertama yang ditemukan
      String? name = querySnapshot.docs.first.get('name');
      return name;
    } else {
      // Jika tidak ada dokumen yang ditemukan
      return null;
    }
  } catch (e) {
    // Handle kesalahan jika terjadi
    print('Error fetching user data: $e');
    return null;
  }
}

  // Read login status
  bool readLoginStatus() {
    bool? statusLogin = prefs.getBool('isLogin');
    String? userUid = prefs.getString('userUid');

    if (statusLogin == true && userUid != null) {
      // User is logged in, navigate to the profile page
      Navigator.pop(context);

      // Use Navigator.pushReplacementNamed to replace the current route with a new instance of Profil
      Navigator.pushReplacementNamed(context, '/home');
    }

    return statusLogin ?? false;
  }

  startLogin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Login successful
      setState(() {
        //statuslogin = true;
        error = false;
        showprogress = false;
        errormsg = 'Login Berhasil!\nEmail : ' + userCredential.user!.email!;
      });

      saveLoginStatus(userCredential.user!);

      Navigator.pop(context);

      // Use Navigator.pushReplacementNamed to replace the current route with a new instance of Profil
      Navigator.pushReplacementNamed(context, '/home');

      //MyAppState.setUserEmail(userCredential.user!.email!);
    } on FirebaseAuthException catch (e) {
      // Login failed
      setState(() {
        showprogress = false;
        error = true;
        errormsg = e.message!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        //centerTitle: true,
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
                  'Login SoloGather',
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
                    'Login ke SoloGather untuk menggunakan layanan-layanan dari SoloGather',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
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
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // change password text
                      password = value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  padding: EdgeInsets.all(10),
                  child: error ? errmsg(errormsg) : SizedBox(height: 30),
                ),
                Container(
                  width: 400,
                  height: 38,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[500],
                    ),
                    onPressed: () {
                      setState(() {
                        //show progress indicator on click
                        showprogress = true;
                      });
                      startLogin();
                    },
                    child: showprogress
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.orange[100],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.deepOrangeAccent),
                            ),
                          )
                        : Text(
                            "Masuk",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            'Daftar Sekarang',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Text('atau'),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            // Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            'Lupa Password?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 400,
                        height: 40,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Sign in with Google
                          },
                          icon: new Image.asset('assets/images/google.png',
                              fit: BoxFit.cover),
                          label: Text(
                            'Masuk dengan Google',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary:
                                Colors.white, // set the button color to yellow
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                      Container(
                        width: 400,
                        height: 40,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.facebook,
                            size: 32,
                          ),
                          label: Text('Masuk dengan Facebook'),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 400,
                        alignment: Alignment.center,
                        child: Text(
                          'Dengan masuk atau mendaftar, Anda menyetujui Ketentuan Layanan dan Kebijakan Privasi SoloGather.',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center, // add this line
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  InputDecoration myInputDecoration(
      {required String label, required IconData icon}) {
    return InputDecoration(
      hintText: label, //show label as placeholder
      hintStyle:
          TextStyle(color: Colors.orange[100], fontSize: 20), //hint text style
      prefixIcon: Padding(
          padding: EdgeInsets.only(left: 20, right: 10),
          child: Icon(
            icon,
            color: Colors.orange[100],
          )
          //padding and icon for prefix
          ),

      contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
              color: Colors.orange, width: 1)), //default border of input

      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide:
              BorderSide(color: Colors.orange, width: 1)), //focus border

      fillColor: Color.fromRGBO(251, 140, 0, 0.5),
      filled: true, //set true if you want to show input background
    );
  }

  Widget errmsg(String text) {
    //error message widget.
    if (statusLogin == false) {
      return Container(
        padding: EdgeInsets.all(7.00),
        margin: EdgeInsets.only(bottom: 4.00),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.red,
            border: Border.all(color: Colors.red, width: 2)),
        child: Row(children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 6.00),
            child: Icon(Icons.error, color: Colors.white),
          ),
          Expanded(
            child:
                Text(text, style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ]),
      );
    } else {
      return Container();
    }
  }
}
