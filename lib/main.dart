import 'package:chat/AppProvider.dart';
import 'package:chat/addRoom/AddRoom.dart';
import 'package:chat/addRoom/ChatScreen.dart';
import 'package:chat/addRoom/RoomDetailsScreen.dart';
import 'package:chat/auth/LoginScreen.dart';
import 'package:chat/auth/RegisterScreen.dart';
import 'package:chat/home/HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(create: (context)=>AppProvider(),
      builder: (context,widget){
      final provider = Provider.of<AppProvider>(context);
       return MaterialApp(
          title: 'Flutter Demo',
          routes: {
           LoginScreen.ROUTE_NAME: (context) => LoginScreen(),
            RegisterScreen.ROUTE_NAME: (context) => RegisterScreen(),
            HomeScreen.ROUTE_NAME: (context) => HomeScreen(),
            AddRoom.ROUTE_NAME: (context) => AddRoom(),
            RoomDetailsScreen.ROUTE_NAME: (context) => RoomDetailsScreen(),
            ChatScreen.ROUTE_NAME: (context) => ChatScreen()
          },
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: provider.currentUser==null?LoginScreen():
         HomeScreen(),
        );
      }


    );
  }
}
