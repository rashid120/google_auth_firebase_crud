
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_auth/ui_helper/costume_widget.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController(text: 'Firebase description');

  File? _imageUri;

  getImage(ImageSource imageSource) async{

    final ImagePicker imagePicker = ImagePicker();
    final XFile? imagePath = await imagePicker.pickImage(source: imageSource);

    if(imagePath != null){
      setState(() {
        _imageUri = File(imagePath.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    var view = CostumeWidget(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Storage'), centerTitle: true, backgroundColor: Colors.blue, foregroundColor: Colors.white,),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Align(
                alignment: Alignment.center,
                child: InkWell(
                  splashColor: Colors.blue.shade200,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: _imageUri != null ? FileImage(_imageUri!) : null,
                    child: _imageUri == null? const Icon(Icons.person, color: Colors.white,) : null,
                  ),
                  onTap: (){
                    getImage(ImageSource.gallery);
                  },
                ),
              ),

              const Text('Title', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(
                height: 60,
                child: view.myTextFieldView(
                  horizontal: 0,
                  controller: titleController,
                  labelText: 'Firebase description',
                  border: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),

              const SizedBox(height: 15,),
              const Text('Description', style: TextStyle(fontWeight: FontWeight.bold),),

              view.myTextFieldView(

                horizontal: 0,
                maxLine: 6,
                minLine: 6,
                controller: descriptionController,
                labelText: 'Firebase description',
                border: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
              ),

              view.myButtonView(
                btnName: 'Add Item',
                onPressed: (){

                  if(titleController.text.isEmpty || descriptionController.text.isEmpty || _imageUri == null){

                  }else{
                    progressBar();
                    uploadInStorage();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadInStorage() async{

    FirebaseStorage storage = FirebaseStorage.instance;
    var current = DateTime.now().millisecondsSinceEpoch;

    var imageName = _imageUri!.path.split('/').last;
    var imageType = imageName.split('.').last;

    Reference ref = storage.ref('notes').child(imageName);
    UploadTask uploadTask = ref.putFile(_imageUri!, SettableMetadata(contentType: "image/$imageType"));

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadImage = await taskSnapshot.ref.getDownloadURL();

    CollectionReference firestore = FirebaseFirestore.instance.collection('Notes');

    Map<String, dynamic> notesData = {

      'title' : titleController.text,
      'description' : descriptionController.text,
      'image' : downloadImage,
      'imageName' : imageName
    };

    firestore.add(notesData)
    .then((value){

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successful')));
      titleController.clear();
      descriptionController.clear();
      Navigator.pop(context);
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(onError.toString())));
      return null;
    });
  }

  progressBar(){

    showDialog(context: context, barrierDismissible: false, builder: (context){
      return const Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(color: Colors.blue, radius: 20,),
          Text('Uploading...', style: TextStyle(fontSize: 17, decoration: TextDecoration.none, color: Colors.green),)
        ],
      ),);
    });
  }
}
