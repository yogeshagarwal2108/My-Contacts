import 'package:flutter/material.dart';
import '../model/contact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  String _firstName= "";
  String _lastName= "";
  String _email= "";
  String _phone= "";
  String _address= "";
  String _photoUrl= "empty";

  Contact contact;
  DatabaseReference _databaseReference= FirebaseDatabase.instance.reference();

  saveContact() async{
    if(_firstName.isNotEmpty && _lastName.isNotEmpty && _email.isNotEmpty && _phone.isNotEmpty && _address.isNotEmpty){
      contact= Contact(this._firstName, this._lastName, this._email, this._phone, this._address, this._photoUrl);

      await _databaseReference.push().set(contact.toJson());
      moveToLastScreen();
    }
    else{
      return showDialog(
        context: context,
        builder: (context)=> AlertDialog(
          title: Text("Fields required"),
          content: Text("All fields are required"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancle"),
              onPressed: (){
                moveToLastScreen();
              },
              color: Colors.indigo,
            ),
          ],
        ),
      );
    }
  }
  moveToLastScreen(){
    Navigator.pop(context);
  }

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
        _photoUrl= downloadUrl;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
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
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _photoUrl== "empty" ? AssetImage("assets/logo.png") : NetworkImage(_photoUrl),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: TextField(
                onChanged: (input){
                  _firstName= input;
                },
                decoration: InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: TextField(
                onChanged: (input){
                  _lastName= input;
                },
                decoration: InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: TextField(
                onChanged: (input){
                  _email= input;
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: TextField(
                onChanged: (input){
                  _phone= input;
                },
                decoration: InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: TextField(
                onChanged: (input){
                  _address= input;
                },
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),


            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                color: Colors.indigoAccent,
                child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, letterSpacing: 1.2),),
                padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.indigo),
                ),

                onPressed: (){
                  saveContact();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
















//import 'package:flutter/material.dart';
//import "package:firebase_login/model/contact.dart";
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:path/path.dart' as Path;
//import 'dart:io';
//
//class AddContact extends StatefulWidget {
//  @override
//  _AddContactState createState() => _AddContactState();
//}
//
//class _AddContactState extends State<AddContact> {
//
//  String _firstName= "";
//  String _lastName= "";
//  String _email= "";
//  String _phone= "";
//  String _address= "";
//  String _photoUrl= "empty";
//
//  DatabaseReference databaseReference= FirebaseDatabase.instance.reference();
//
//  saveContact() async{
//    if(_firstName.isNotEmpty && _lastName.isNotEmpty  && _email.isNotEmpty  && _phone.isNotEmpty  && _address.isNotEmpty  && _photoUrl.isNotEmpty ){
//      Contact contact= Contact(this._firstName, this._lastName, this._email, this._phone, this._address, this._photoUrl);
//
//      await databaseReference.push().set(contact.toJson());
//      moveToLastScreen();
//    }
//    else{
//      showDialog(
//        context: context,
//        builder: (context)=> AlertDialog(
//          title: Text("Fields required"),
//          content: Text("All fields are required"),
//          actions: <Widget>[
//            FlatButton(
//              child: Text("Cancle"),
//              onPressed: (){
//                Navigator.pop(context);
//              },
//            ),
//          ],
//        ),
//      );
//    }
//  }
//
//  moveToLastScreen(){
//    Navigator.pop(context);
//  }
//
//
//  pickImage() async{
//    File file= await ImagePicker.pickImage(source: ImageSource.gallery);
//    String fileName= Path.basename(file.path);
//    uploadImage(file, fileName);
//  }
//
//  uploadImage(File file, String fileName) async{
//    StorageReference storageReference= FirebaseStorage.instance.ref().child(fileName);
//    storageReference.putFile(file).onComplete.then((firebaseFile) async{
//      String downloadUrl= await firebaseFile.ref.getDownloadURL();
//
//      setState(() {
//        _photoUrl= downloadUrl;
//      });
//    });
//  }
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Add Contact"),
//        backgroundColor: Colors.blueAccent,
//      ),
//
//      body: Container(
//        padding: EdgeInsets.all(15.0),
//          child: ListView(
//            children: <Widget>[
//              Container(
//                margin: EdgeInsets.only(top: 20.0),
//                child: GestureDetector(
//                  onTap: (){
//                    pickImage();
//                  },
//                  child: Center(
//                    child: Container(
//                      width: 100.0,
//                      height: 100.0,
//                      decoration: BoxDecoration(
//                        shape: BoxShape.circle,
//                        image: DecorationImage(
//                          image: _photoUrl== "empty" ? AssetImage("assets/logo.png") : NetworkImage(_photoUrl),
//                          fit: BoxFit.cover,
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//
//              Container(
//                  padding: EdgeInsets.only(top: 20.0),
//
//                  child: TextField(
//                    onChanged: (value){
//                      _firstName= value;
//                    },
//
//                    decoration: InputDecoration(
//                      border: OutlineInputBorder(
//                        borderRadius: BorderRadius.circular(10.0),
//                      ),
//                      labelText: "First Nam",
//                    ),
//                  ),
//              ),
//              Container(
//                  padding: EdgeInsets.only(top: 10.0),
//
//                  child: TextField(
//                    onChanged: (value){
//                      _lastName= value;
//                    },
//
//                    decoration: InputDecoration(
//                      border: OutlineInputBorder(
//                        borderRadius: BorderRadius.circular(10.0),
//                      ),
//                      labelText: "Last Name",
//                    ),
//                  ),
//              ),
//
//              Container(
//                  padding: EdgeInsets.only(top: 10.0),
//
//                  child: TextField(
//                    onChanged: (value){
//                      _email= value;
//                    },
//
//                    decoration: InputDecoration(
//                      border: OutlineInputBorder(
//                        borderRadius: BorderRadius.circular(10.0),
//                      ),
//                      labelText: "Email",
//                    ),
//                  ),
//              ),
//
//              Container(
//                  padding: EdgeInsets.only(top: 10.0),
//
//                  child: TextField(
//                    onChanged: (value){
//                      _phone= value;
//                    },
//
//                    decoration: InputDecoration(
//                      border: OutlineInputBorder(
//                        borderRadius: BorderRadius.circular(10.0),
//                      ),
//                      labelText: "Phone",
//                    ),
//                  ),
//              ),
//
//            Container(
//              padding: EdgeInsets.only(top: 10.0),
//
//              child: TextField(
//                onChanged: (value){
//                  _address= value;
//                },
//
//                decoration: InputDecoration(
//                  border: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(10.0),
//                  ),
//                  labelText: "Address",
//                ),
//              ),
//            ),
//
//              Container(
//                margin: EdgeInsets.only(top: 20.0),
//                decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(20.0),
//                ),
//                child: RaisedButton(
//                  padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
//                  elevation: 2.0,
//                  child: Text("Save", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
//                  onPressed: (){
//                    saveContact();
//                  },
//                  color: Colors.blueAccent,
//                ),
//              ),
//            ],
//          ),
//      ),
//    );
//  }
//}