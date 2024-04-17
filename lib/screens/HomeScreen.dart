
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phone_auth/firebase_storage/view_data_storage.dart';
import 'package:phone_auth/screens/google_login_page.dart';
import 'package:phone_auth/screens/view_data.dart';
import 'package:phone_auth/ui_helper/costume_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  addData() async{

    CollectionReference collectionReference = FirebaseFirestore.instance.collection("userData");
    Map<String, dynamic> userData = {
      'name' : nameController.text,
      'age' : ageController.text,
      'city' : cityController.text
    };

    collectionReference.add(userData)
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successful')));
          nameController.clear();
          ageController.clear();
          cityController.clear();
        }).catchError((onError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(onError.toString())));
          return null;
        });
    }

  @override
  Widget build(BuildContext context) {

    var auth = FirebaseAuth.instance.currentUser;
    var view = CostumeWidget(context);
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const ViewDataStorage()));
        }, icon: const Icon(Icons.image, color: Colors.white,)),
        title: Text(auth!.displayName.toString(), style: const TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [IconButton(onPressed: () async{
          const CupertinoActivityIndicator();
          await GoogleSignIn().signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GoogleLoginPage()));
        }, icon: const Icon(Icons.logout, color: Colors.white,))],
      ),
      body: Column(
        children: [

          const SizedBox(height: 20,),
          const Text('Firebase Firestore', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),

          const SizedBox(height: 20,),
          view.myTextFieldView(
            controller: nameController,
            labelText: 'Your name'
          ),

          view.myTextFieldView(
            controller: ageController,
            labelText: 'Your age'
          ),

          view.myTextFieldView(
            controller: cityController,
            labelText: 'Your city name'
          ),

          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: view.myButtonView(
                  horizontal: 15,
                  vertical: 15,
                  onPressed: (){
                    if(nameController.text.isEmpty || ageController.text.isEmpty || cityController.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All fields are required')));
                    }else{
                      addData();
                    }
                  },
                  btnName: 'Save'
                ),
              ),
              Expanded(
                flex: 1,
                  child: view.myButtonView(
                    horizontal: 15,
                      vertical: 15,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewData())),
                      btnName: 'View data'
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}
