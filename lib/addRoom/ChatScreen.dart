import 'package:chat/AppProvider.dart';
import 'package:chat/addRoom/MessageDetails.dart';
import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Message.dart';

class ChatScreen extends StatefulWidget {
  static final String ROUTE_NAME = 'chat screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Room room;
  String typedMessage="";
  late CollectionReference<Message> messagesRef;
  late AppProvider provider;
  var controllerMessage = TextEditingController();
  @override
  void initUser() {
    controllerMessage = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as ChatScreenArgs;
    room = args.room!;
    messagesRef= getMessagesCollectionWithConverter(room.id);
    provider= Provider.of<AppProvider>(context);
    final Stream<QuerySnapshot<Message>>messagesStream=messagesRef.orderBy('time').snapshots();

    return Scaffold(

        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("${room.name}"),
        ),
        body:

        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/background.png",
                    ),
                    fit: BoxFit.fill)),
            child: Column(
              children: [
                SizedBox(height: 150,),
                Flexible(
                  child: Center(
                      child: Container(
                        width: 350,
                        height: 650,
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
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                               Expanded(child: StreamBuilder<QuerySnapshot<Message>>(
                            stream: messagesStream,
                                 builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Message>> snapshot){
                                   if (snapshot.hasError) {
                                     return Text('Something went wrong');
                                   }
                                   else if(snapshot.hasData)
                                     {
                                       return ListView.builder(itemBuilder: (buildContext,index){
                                        return MessageWidget(snapshot.data?.docs[index].data());
                                       },itemCount: snapshot.data?.size??0,
                                       );
                                     }
                                   else return Center(child: CircularProgressIndicator(),);
                                 },
                               ),),

                              Row(children: [
                                Container(
                                  width: 210,
                                  height: 45,

                                  child: TextField(
                                    controller: controllerMessage,


                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),hintText: "Type a message",border: OutlineInputBorder(

                                        borderRadius: BorderRadius.only(topRight: Radius.circular(10))
                                    )),
                                  ),
                                ),
                                SizedBox(width: 15,),

                                Container(width: 85,height: 45,
                                    decoration: BoxDecoration(color: Colors.lightBlue,borderRadius: BorderRadius.circular(10)),
                                    child: InkWell(
                                      onTap: (){sendMessage();},
                                      child: Center(
                                        child: Row(

                                  children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Send",style: TextStyle(color: Colors.white),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image(image: AssetImage("assets/send.png"),),
                                        ),
                                  ],
                                ),
                                      ),
                                    ))
                              ],)
                            ],
                          ),
                        ),
                      )
                  ),
                ),
              ],
            )
        )
    );
  }
  void sendMessage(){
    if(controllerMessage.text.isEmpty)return;
    print(controllerMessage.text);
    final newMessageObj= messagesRef.doc();
    final message=Message(id: newMessageObj.id, content: controllerMessage.text,senderId: provider.currentUser!.id, senderName: provider.currentUser!.userName, time: DateTime.now().millisecondsSinceEpoch);
    newMessageObj.set(message).then((value){setState(() {
      controllerMessage.text="";
    });});
  }
}

class ChatScreenArgs {
  Room? room;

  ChatScreenArgs(this.room);
}
