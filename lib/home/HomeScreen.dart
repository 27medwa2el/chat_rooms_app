import 'package:chat/addRoom/AddRoom.dart';
import 'package:chat/auth/LoginScreen.dart';
import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/home/RoomWidget.dart';
import 'package:chat/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static final String ROUTE_NAME = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference<Room> roomsCollectionRef =
        getRoomsCollectionWithConverter();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddRoom.ROUTE_NAME);
          },
          child: Icon(Icons.add),
        ),
        extendBodyBehindAppBar: true,
        drawer: Drawer(
           child: InkWell(
             onTap: (){
               setState(() {
                 FirebaseAuth.instance.signOut();
                 Navigator.of(context).pushReplacementNamed(LoginScreen.ROUTE_NAME);
               });
               
             },
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                Text("Log out"),Icon(Icons.logout)
               ],
             ),
           ),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Rooms"),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/background.png",
                    ),
                    fit: BoxFit.fill)),
            child: FutureBuilder<QuerySnapshot<Room?>>(
              future: roomsCollectionRef.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Room?>> snapshot) {
                if (snapshot.hasError) {
                  return Text("something wrong");
                } else if (snapshot.connectionState == ConnectionState.done) {
                  final List <Room?> roomsList = snapshot.data!.docs
                          .map((singleDoc) => singleDoc.data())
                          .toList() ??
                      [];
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4),
                      itemCount: roomsList.length,
                      itemBuilder: (buildContext, index) {
                        return RoomWidget(roomsList[index]);
                      });
                } else {
                  return CircularProgressIndicator();
                }
              },
            )));
  }
}
