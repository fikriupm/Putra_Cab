import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:putra_cab/AllScreen/mainScreen.dart';
import 'package:putra_cab/AllScreen/registrationScreen.dart';
import 'package:putra_cab/AllWidgets/progressDialog.dart';
import 'package:putra_cab/main.dart';

class loginScreen extends StatelessWidget {
  loginScreen({super.key});

  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 45.0,
              ),
              Image(
                image: AssetImage("gambar PutraCab/logo with name.png"),
                width: 280.0,
                height: 150.0,
                alignment: Alignment.topCenter,
              ),
              SizedBox(
                height: 0.1,
              ),
              Text(
                "Student",
                style: TextStyle(
                    fontSize: 34.0,
                    backgroundColor: Colors.pink[800],
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      height: 10.1,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email Student",
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10.1,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10.1,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.pink[800]),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(15)),
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontSize: 14, color: Colors.white))),
                      onPressed: () {
                        if (!emailTextEditingController.text.contains("@")) {
                          displayToastMsg(
                              "Email address is not valid. ", context);
                        } else if (passwordTextEditingController.text.isEmpty) {
                          displayToastMsg("Password is mandatory. ", context);
                        } else {
                          loginAndAuthUser(context);
                          print("Loggedin button clicked");
                        }
                      },
                      child: Container(
                        height: 35.0,
                        child: Center(
                            child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18.0),
                        )),
                      ),
                    )
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, registrationScreen.idScreen, (route) => false);
                  },
                  child: Text("Do not have an account? Register here")),
              SizedBox(
                height: 0.1,
              ),
              Image(
                image: AssetImage("gambar PutraCab/bottom.png"),
                width: 580.0,
                height: 200.0,
                alignment: Alignment.bottomCenter,
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthUser(BuildContext context) async {
  // showDialog(
  //   context: context,
  //   barrierDismissible: false,
  //   builder: (BuildContext context),
  //   {
  //     return ProgressDialog(message: "Authentication, please wait...",);

  //   }
  //   );

    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMsg("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      //save user info to database
      usersRef
          .child(firebaseUser.uid)
          .once()
          .then((value) => (DataSnapshot snap) {
                if (snap.value != null) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, mainScreen.idScreen, (route) => false);
                  displayToastMsg("You are logged-in now. ", context);
                } else {
                  _firebaseAuth.signOut();
                  displayToastMsg(
                      "No record exists for this user. Please new craete account. ",
                      context);
                }
              });
    } else {
      //error occured - display error message
      displayToastMsg("Error occured, can not sign in", context);
    }
  }
}
