import 'package:chat/AppProvider.dart';
import 'package:chat/auth/RegisterScreen.dart';
import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/home/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat/model/User.dart'as user;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static final String ROUTE_NAME = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
late AppProvider provider;
final FirebaseAuth auth = FirebaseAuth.instance;
String email = "";
String password = "";
String name = "";
final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    provider= Provider.of<AppProvider>(context);
    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Image(
          image: AssetImage(
            "assets/background.png",
          ),
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Create Account"),
          ),
          body: Form(
            key: _formkey,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/background.png",
                      ),
                      fit: BoxFit.fill)),
              child: Column(
                children: [
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 17,
                        ),
                        Padding(padding: const EdgeInsets.all(15.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Welcome back!",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        )
                          ,),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty | !value.contains('@'))
                                  return "Enter the mail correctly";
                                else
                                  return null;
                              },
                              initialValue: email,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)),
                                  labelText: 'E-mail',
                                  labelStyle: TextStyle(color: Colors.grey)),
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return "Enter a vaild passwoed";
                                else
                                  return null;
                              },
                              initialValue: password,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.grey)),
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              }),
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Forgot password?"
                                ,style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,color: Colors.black
                              ),

                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                          EdgeInsets.only(bottom: 45, right: 20, left: 20, top: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.lightBlue,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, 3))
                              ]),
                          child: InkWell(
                            onTap: () {
                              enterFireBaseUser();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: isLoading?
                                      Center(child: CircularProgressIndicator())

                                 : Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),

                        ),


                        InkWell(
                          onTap: ()=>Navigator.pushNamed(context, RegisterScreen.ROUTE_NAME),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text("or Create new account",style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                              ),),
                            ),
                          ),
                        )
                      ],
                    ),
                    flex: 2,
                  ),


                ],
              ),
            ),
          ),
        )
      ],
    );
  }
  final dp= FirebaseFirestore.instance;

  bool isLoading = false;

  void enterFireBaseUser() async {
    if(_formkey.currentState!.validate()==true) {
    setState(() {
      isLoading = true;
    });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user == null) {
          Fluttertoast.showToast(msg: "Invalid user");
        }
        else {
          getUsersCollectionWithConverter().doc(
              userCredential.user!.uid).get().then((retrievedUser) {
            provider.updateUser(retrievedUser.data());
            setState(() {
              isLoading = false;
            });
          });
          Fluttertoast.showToast(msg: "Logged in successfully");
          Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_NAME);
        }
      }


      on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }
}
