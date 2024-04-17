import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/ui_helper/costume_widget.dart';

class ViewData extends StatefulWidget {
  const ViewData({Key? key}) : super(key: key);

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Firestore', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('userData').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data?.docs[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(data!['age'].toString()),
                  ),
                  title: Text("Name : ${data['name']}"),
                  subtitle: Text("City : ${data['city']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('userData')
                              .doc(data.id)
                              .delete()
                              .then((value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successful'))));
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () {
                          bottomSheet(data);
                        },
                        icon: const Icon(Icons.update, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _updateData(String userId) {

    FirebaseFirestore.instance.collection('userData').doc(userId).update({
      'name': nameController.text,
      'age': ageController.text,
      'city': cityController.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update Successful')));
      Navigator.pop(context);
    });
  }

  void bottomSheet(QueryDocumentSnapshot user) {

    nameController = TextEditingController(text: user['name']);
    ageController = TextEditingController(text: user['age']);
    cityController = TextEditingController(text: user['city']);

    var view = CostumeWidget(context);
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    const Text('Update', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                    const SizedBox(height: 20,),

                    view.myTextFieldView(controller: nameController, labelText: 'Your new name'),
                    view.myTextFieldView(controller: ageController, labelText: 'Your new age'),
                    view.myTextFieldView(controller: cityController, labelText: 'Your new city'),

                    view.myButtonView(
                      onPressed: () {
                        if (nameController.text.isEmpty || ageController.text.isEmpty || cityController.text.isEmpty) {

                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All fields are required')));
                          Navigator.pop(context);
                        } else {
                          _updateData(user.id);
                        }
                      },
                      btnName: 'Update'
                    ),
                    const SizedBox(height: 10,),
                  ],
                ),
              ),
            ));
  }
}
