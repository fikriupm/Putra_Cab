import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:putra_cab/AllScreen/loginScreen.dart';
import 'package:putra_cab/AllScreen/mainScreen.dart';
import 'package:putra_cab/main.dart';

class registrationScreen extends StatelessWidget {
  registrationScreen({super.key});

  static const String idScreen = "register";
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
                "Register as a Student",
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
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
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
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "No Phone",
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
                        if (nameTextEditingController.text.length < 3) {
                          displayToastMsg(
                              "Name must be 3 characters. ", context);
                        } else if (!emailTextEditingController.text
                            .contains("@")) {
                          displayToastMsg(
                              "Email address is not valid. ", context);
                        } else if (phoneTextEditingController.text.isEmpty) {
                          displayToastMsg(
                              "Phone number is mandatory. ", context);
                        } else if (passwordTextEditingController.text.length <
                            6) {
                          displayToastMsg(
                              "Password must be atleast 6 character. ",
                              context);
                        } else {
                          registerNewUser(context);
                          print("Loggedin button clicked");
                        }
                      },
                      child: Container(
                        height: 35.0,
                        child: Center(
                            child: const Text(
                          'Register',
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
                        context, loginScreen.idScreen, (route) => false);
                  },
                  child: Text("Already have an account? Login here")),
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

  void registerNewUser(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMsg("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      //user created
      //save user info to databas
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMsg("Your account has been created. ", context);

      Navigator.pushNamedAndRemoveUntil(
          context, mainScreen.idScreen, (route) => false);
    } else {
      //error occured - display error message
      displayToastMsg("New user account has not been Craeted", context);
    }
  }
}

displayToastMsg(String msg, BuildContext context) {
  Fluttertoast.showToast(msg: msg);
}
