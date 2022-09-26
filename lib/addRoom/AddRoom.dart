import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/model/Room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({Key? key}) : super(key: key);
  static final String ROUTE_NAME = 'add room';
  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  String roomName="";
  String roomDescription="";
  List<String>categories=['sports','movies','music'];
  String selectedCategory="sports";
  bool isLoading = false;
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,

          title: Text("Chat app"),
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
              child:Center(
                child: Container(
                  width: 350,
                  height: 550,

                  decoration: BoxDecoration(
                      color: Colors.white,
                    boxShadow:   [
                  BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3))
                  ],
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("Create new room",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 22),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image(image: AssetImage("assets/add_room_header.png")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Enter the name correctly";
                              else
                                return null;
                            },

                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                labelText: 'Enter room name',
                                labelStyle: TextStyle(color: Colors.grey)),
                            onChanged: (value) {
                              setState(() {
                                 roomName=value;
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty||value==null)
                                return "Enter the name correctly";
                              else
                                return null;
                            },

                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                labelText: 'Enter room description',
                                labelStyle: TextStyle(color: Colors.grey)),
                            onChanged: (value) {
                              setState(() {
                              roomDescription=value;
                              });
                            }),
                      ),

                      DropdownButton<String>(
                        value: selectedCategory,
                        iconSize: 24,
                        elevation: 16,
                        items: categories.map((String name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Row(
                              children: [
                                Image(image: AssetImage('assets/${name}.png')),
                                Text(name)
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (newSelected) {
                          setState(() {
                            selectedCategory = newSelected as String;
                          });

                        },

                      ),
                      Spacer(),
                      InkWell(
                        onTap: (){
                          if(_formkey.currentState!.validate()==true)
                            {
                              addRoom();
                            }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(decoration: BoxDecoration(

                              color: Colors.lightBlue,

                            borderRadius: BorderRadius.circular(15)
                          ),width: 200,
                            child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                              child: isLoading?
                                  CircularProgressIndicator():
                              Text(
                                "Create",
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),),
                        ),
                      )


                    ],
                  ),
                ),
              )
          ),
        )
    );
  }
  void addRoom(){
       setState(() {
         isLoading=true;
       });
        final docRef= getRoomsCollectionWithConverter().doc();
         Room room = Room(id: docRef.id, category: selectedCategory, name: roomName, description: roomDescription);
         docRef.set(room).then((value) {
           setState(() {
             isLoading=false;
           });
            Fluttertoast.showToast(msg: "Room created successfully",toastLength: Toast.LENGTH_LONG);
            Navigator.pop(context);
         });
  }
}
