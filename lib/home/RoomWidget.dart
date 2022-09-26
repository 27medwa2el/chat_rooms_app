import 'package:chat/addRoom/RoomDetailsScreen.dart';
import 'package:chat/model/Room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget {


  Room? room;

  RoomWidget(this.room);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
         Navigator.pushNamed(context, RoomDetailsScreen.ROUTE_NAME,arguments: RoomDetailsArgs(room));
      },
      child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: 160,
            width: 120,
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
            child: Column(
              children: [
                Image(width: 75,

                    fit: BoxFit.fitHeight,
                    image: AssetImage("assets/${room!.category}.png")),
                Text(room!.name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
              ],
            ),
          )),
    );
  }
}
