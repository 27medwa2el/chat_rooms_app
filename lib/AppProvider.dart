import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/model/User.dart' as myUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier{
  myUser.User? currentUser;

  AppProvider(){
  final firebaseUser=FirebaseAuth.instance.currentUser;
  if(firebaseUser!=null){
  getUsersCollectionWithConverter().doc(firebaseUser.uid).get().then((retrievedUser){
    currentUser=retrievedUser.data();
    notifyListeners();
  });
  }
  }
  updateUser(myUser.User? user){
    currentUser = user;
    notifyListeners();
  }
  void logOut(){
    FirebaseAuth.instance.signOut();
  }
}