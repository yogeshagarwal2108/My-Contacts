import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import '../model/contact.dart';

class EditContact extends StatefulWidget {

  String id;
  EditContact(this.id);

  @override
  _EditContactState createState() => _EditContactState(this.id);
}

class _EditContactState extends State<EditContact> {

  String id;
  bool isLoading= true;
  _EditContactState(this.id);

  String firstName= "";
  String lastName= "";
  String email= "";
  String phone= "";
  String address= "";
  String photoUrl;
  DatabaseReference _databaseReference= FirebaseDatabase.instance.reference();

  TextEditingController fnController= TextEditingController();
  TextEditingController lnController= TextEditingController();
  TextEditingController emController= TextEditingController();
  TextEditingController phController= TextEditingController();
  TextEditingController adController= TextEditingController();

  getContact(id) async{
    Contact contact;

    _databaseReference.child(id).onValue.listen((event){
      contact= Contact.fromSnapshot(event.snapshot);

      fnController.text= contact.firstName;
      lnController.text= contact.lastName;
      emController.text= contact.email;
      phController.text= contact.phone;
      adController.text= contact.address;

      setState(() {
        firstName= contact.firstName;
        lastName= contact.lastName;
        email= contact.email;
        phone= contact.phone;
        address= contact.address;
        photoUrl= contact.photoUrl;
      print("name  :  ${firstName}");

        isLoading= false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getContact(id);
    print("id   :   ${id}");
  }


  updateContact(id) async{
    Contact _contact;
    if(firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty && phone.isNotEmpty && address.isNotEmpty){
      _contact= Contact.withId(this.id, this.firstName, this.lastName, this.email, this.phone, this.address, this.photoUrl);

      _databaseReference.child(id).set(_contact.toJson());
      moveToLastScreen();
    }
  }

  moveToLastScreen(){
    Navigator.pop(context);
  }

  //pick image
  pickImage() async{
    File file= await ImagePicker.pickImage(source: ImageSource.gallery);
    String fileName= Path.basename(file.path);
    uploadImage(file, fileName);
  }
  uploadImage(File file, String fileName) async{
    StorageReference _storageReference= FirebaseStorage.instance.ref().child(fileName);
    _storageReference.putFile(file).onComplete.then((firebaseFile) async{
      String downloadUrl= await firebaseFile.ref.getDownloadURL();

      setState(() {
        photoUrl= downloadUrl;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
        backgroundColor: Colors.indigoAccent,
      ),

      body: Container(
        padding: EdgeInsets.all(10.0),
        child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: (){
                        pickImage();
                      },

                      child: Center(
                        child: Container(
                          height: 150.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: photoUrl== "empty" ? AssetImage("assets/logo.png") : NetworkImage(photoUrl),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: fnController,
                      onChanged: (input){
                        firstName= input;
                      },
                      decoration: InputDecoration(
                        labelText: "First Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: lnController,
                      onChanged: (input){
                        lastName= input;
                      },
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: emController,
                      onChanged: (input){
                        email= input;
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: phController,
                      onChanged: (input){
                        phone= input;
                      },
                      decoration: InputDecoration(
                        labelText: "Phone",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: adController,
                      onChanged: (input){
                        address= input;
                      },
                      decoration: InputDecoration(
                        labelText: "Address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: RaisedButton(
                      color: Colors.indigo,
                      padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                      child: Text("Update", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                      onPressed: (){
                        updateContact(id);
                      },
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}