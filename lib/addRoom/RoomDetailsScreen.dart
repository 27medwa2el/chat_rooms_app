import 'package:chat/addRoom/ChatScreen.dart';
import 'package:chat/model/Room.dart';
import 'package:flutter/material.dart';

class RoomDetailsScreen extends StatelessWidget {
  static final String ROUTE_NAME = 'room details';
  late Room room;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as RoomDetailsArgs;
    room = args.room!;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Chat app"),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/background.png",
                    ),
                    fit: BoxFit.fill)),
            child: Center(
                child: Container(
              width: 350,
              height: 600,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 3))
                  ],
                  borderRadius: BorderRadius.circular(20)),
             child: Padding(
               padding: const EdgeInsets.all(25.0),
               child: Column(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
                     child: Text("Hello welcome to our chat room",style: TextStyle(fontWeight: FontWeight.w400),),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
                     child: Text("Join ${room.name}!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Image(image: AssetImage("assets/${room.category}.png")),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text("${room.description}"),
                   ),
                   TextButton(onPressed: (){
                     Navigator.pushNamed(context, ChatScreen.ROUTE_NAME,arguments: ChatScreenArgs(room));
                   }, child: Container(decoration: BoxDecoration(

                       color: Colors.lightBlue,

                       borderRadius: BorderRadius.circular(6)
                   ),width: 120,height:40,child: Center(child: Text("Join",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))))
                 ],
               ),
             ),
                )
            )
        )
    );
  }
}

class RoomDetailsArgs {
  Room? room;

  RoomDetailsArgs(this.room);
}
