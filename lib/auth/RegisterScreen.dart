import 'package:chat/AppProvider.dart';
import 'package:chat/auth/LoginScreen.dart';
import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/home/HomeScreen.dart';
import 'package:chat/model/User.dart'as user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static final String ROUTE_NAME = 'register';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
String email = "";
String password = "";
String name = "";
late AppProvider provider;
class _RegisterScreenState extends State<RegisterScreen> {

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
          body: Container(
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
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Enter a vaild name";
                              else
                                return null;
                            },
                            initialValue: password,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                labelText: 'First name',
                                labelStyle: TextStyle(color: Colors.grey)),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            }),
                      ),
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
                    ],
                  ),
                  flex: 2,
                ),
                Container(
                  margin:
                      EdgeInsets.only(bottom: 45, right: 20, left: 20, top: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3))
                      ]),
                  child: InkWell(
                    onTap: (){
                      createFireBaseUser();
                    },

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                color: Colors.grey, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
  final dp= FirebaseFirestore.instance;

  bool isLoading = false;

  void createFireBaseUser() async {
    setState(() {
      isLoading = true;
    });
    try{
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final  usersCollectionRef = getUsersCollectionWithConverter();
    final myUser = user.User(id: userCredential.user!.uid, email: email, userName: name);
    usersCollectionRef.doc(myUser.id).set(myUser).then((value) { provider.currentUser=myUser;
    SnackBar(content: Text("Adding user"),
      duration: Duration(seconds: 3),);
    Navigator.pushNamed(context, HomeScreen.ROUTE_NAME);

    }
    );

    }
        on FirebaseAuthException catch(e)
    {
      SnackBar(content: Text(e.toString()),
      duration: Duration(seconds: 3),);
    }
  }
}
