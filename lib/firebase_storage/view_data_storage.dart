import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/firebase_storage/add_image.dart';

class ViewDataStorage extends StatefulWidget {
  const ViewDataStorage({super.key});

  @override
  State<ViewDataStorage> createState() => _ViewDataStorageState();
}

class _ViewDataStorageState extends State<ViewDataStorage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Storage'), centerTitle: true, backgroundColor: Colors.blue,),

      body: StreamBuilder(stream: FirebaseFirestore.instance.collection('Notes').snapshots(), builder: (context, snapshot) {

        if(snapshot.hasData){

          return ListView.builder(itemCount: snapshot.data?.docs.length,itemBuilder: (context, index){
          var data = snapshot.data?.docs[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(data!['image']),
              ),
              title: Text(data['title']),
              subtitle: Text(data['description']),
              trailing: IconButton(onPressed: (){

                FirebaseFirestore.instance.collection('Notes').doc(data.id);
               FirebaseStorage.instance.refFromURL(data['image']).delete();

              }, icon: const Icon(Icons.delete, color: Colors.red,)),
            );
          });
        }else{

          return const Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(color: Colors.blue, radius: 20,),
              Text('Loading...', style: TextStyle(fontSize: 17, decoration: TextDecoration.none, color: Colors.blue),)
            ],
          ),);
        }
      },),

      floatingActionButton: FloatingActionButton(onPressed: (){

        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddImage()));
      }, child: const Icon(Icons.add, color: Colors.white),),
    );
  }
}
