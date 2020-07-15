import 'package:firebase_login/Screens/edit_contact.dart';
import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';
import '../model/contact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ViewContact extends StatefulWidget {

  String id;
  ViewContact(this.id);

  @override
  _ViewContactState createState() => _ViewContactState(this.id);
}

class _ViewContactState extends State<ViewContact> {

  String id;
  _ViewContactState(this.id);

  bool isLoading= true;
  DatabaseReference _databaseReference= FirebaseDatabase.instance.reference();
  Contact contact;

  getContact(id) async{
    await _databaseReference.child(id).onValue.listen((event){
      contact= Contact.fromSnapshot(event.snapshot);

      setState(() {
        isLoading= false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getContact(id);
  }


  callAction(String number) async{
    String url= "tel:$number";
    if(await canLaunch(url)){
      launch(url);
    }
    else{
      throw "Could not call $number";
    }
  }
  smsAction(String number) async{
      String url= "sms:$number";
      if(await canLaunch(url)){
        launch(url);
      }
      else{
        throw "Could not send sms to $number";
      }
    }


  moveToLastScreen(){
    Navigator.pop(context);
  }
  moveToEditScreen(id){
    Navigator.push(context, MaterialPageRoute(
      builder: (context)=> EditContact(id),
    ));
  }

  deleteContact(id) async{
    moveToLastScreen();
    await _databaseReference.child(id).remove();
    moveToLastScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Contact"),
        backgroundColor: Colors.indigoAccent,
      ),

      body: Container(
        padding: EdgeInsets.all(7.0),
        child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: contact.photoUrl== "empty" ? AssetImage("assets/logo.png") : NetworkImage(contact.photoUrl),
                      ),
                    ),
                  ),
                ),

                Card(
                  margin: EdgeInsets.only(top: 20.0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.indigo),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.perm_identity),
                        Container( width: 15.0, ),
                        Expanded(
                          child: Container(
                            child: Text("${contact.firstName} ${contact.lastName}", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(top: 10.0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.indigo),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.email),
                        Container( width: 15.0, ),
                        Expanded(
                          child: Container(
                            child: Text("${contact.email}", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(top: 10.0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.indigo),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.phone),
                        Container( width: 15.0, ),
                        Container(
                          child: Text("${contact.phone}", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(top: 10.0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.indigo),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.home),
                        Container( width: 15.0, ),
                        Expanded(
                          child: Container(
                            child: Text("${contact.address}", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  margin: EdgeInsets.only(top: 20.0),
//                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.call),
                            iconSize: 35.0,
                            onPressed: (){
                              callAction(contact.phone);
                            },
                          ),
                        ),
                        Container(
                          child: IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.sms),
                            iconSize: 35.0,
                            onPressed: (){
                              smsAction(contact.phone);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(top: 10.0),
//                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.edit),
                            iconSize: 30.0,
                            onPressed: (){
                              moveToEditScreen(contact.id);
                            },
                          ),
                        ),
                        Container(
                          child: IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.delete),
                            iconSize: 30.0,
                            onPressed: (){
                              deleteContact(contact.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}















//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:url_launcher/url_launcher.dart';
//import '../model/contact.dart';
//import 'edit_contact.dart';
//
//class ViewContact extends StatefulWidget {
//
//  String id;
//  ViewContact(this.id);
//
//  @override
//  _ViewContactState createState() => _ViewContactState(this.id);
//}
//
//class _ViewContactState extends State<ViewContact> {
//
//  String id;
//  bool isLoading= true;
//  _ViewContactState(this.id);
//  DatabaseReference databaseReference= FirebaseDatabase.instance.reference();
//  Contact _contact;
//
//  getContact(id) async{
//    await databaseReference.child(id).onValue.listen((event){
//      _contact= Contact.fromSanpshot(event.snapshot);
//      setState(() {
//        isLoading= false;
//      });
//    });
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    getContact(id);
//  }
//
//
//  callAction(String number) async{
//    String url= "tel:$number";
//
//    if(await canLaunch(url)){
//      launch(url);
//    }
//    else{
//      throw "Could not call $number";
//    }
//  }
//  smsAction(String number) async{
//    String url= "sms:$number";
//
//    if(await canLaunch(url)){
//      launch(url);
//    }
//    else{
//      throw "Could not sms to $number";
//    }
//  }
//
//
//  deleteContact(String id) async{
//    return showDialog(
//      context: context,
//      builder: (context)=> AlertDialog(
//        title: Text("Delete Contact"),
//        content: Text("Do you want to delete this contact"),
//        actions: <Widget>[
//          RaisedButton(
//            child: Text("Delete"),
//            onPressed: () async{
//              Navigator.pop(context);
//              await databaseReference.child(id).remove();
//              moveToLastScreen();
//            },
//          ),
//          RaisedButton(
//            child: Text("Cancle"),
//            onPressed: (){
//              Navigator.pop(context);
//            },
//          ),
//        ],
//      ),
//    );
//  }
//
//  editContact(String id){
//    Navigator.push(context, MaterialPageRoute(
//      builder: (context)=> EditContact(id),
//    ));
//  }
//
//  moveToLastScreen(){
//    Navigator.pop(context);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("View Contact"),
//        backgroundColor: Colors.teal,
//      ),
//
//      body: Container(
//        child: isLoading
//          ? Center(
//              child: CircularProgressIndicator(),
//            )
//          : ListView(
//            children: <Widget>[
//              Container(
//                child: Center(
//                  child: Image(
//                    width: 150.0,
//                    height: 150.0,
//                    image: _contact.photoUrl== "empty" ? AssetImage("assets/logo.png") : NetworkImage(_contact.photoUrl),
//                  ),
//                ),
//              ),
//
//              Card(
//                elevation: 2.0,
//                child: Container(
//                  padding: EdgeInsets.only(top: 20.0),
//                  margin: EdgeInsets.all(20.0),
//                  width: double.maxFinite,
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Icon(Icons.perm_identity),
//                      Container(width: 15.0,),
//                      Container(
//                        child: Text("${_contact.firstName} ${_contact.lastName}", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              Card(
//                elevation: 2.0,
//                child: Container(
//                  padding: EdgeInsets.only(top: 10.0),
//                  margin: EdgeInsets.all(20.0),
//                  width: double.maxFinite,
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Icon(Icons.email),
//                      Container(width: 15.0,),
//                      Container(
//                        child: Text("${_contact.email}", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              Card(
//                elevation: 2.0,
//                child: Container(
//                  padding: EdgeInsets.only(top: 10.0),
//                  margin: EdgeInsets.all(20.0),
//                  width: double.maxFinite,
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Icon(Icons.phone),
//                      Container(width: 15.0,),
//                      Container(
//                        child: Text("${_contact.phone}", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              Card(
//                elevation: 2.0,
//                child: Container(
//                  padding: EdgeInsets.only(top: 10.0),
//                  margin: EdgeInsets.all(20.0),
//                  width: double.maxFinite,
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Icon(Icons.home),
//                      Container(width: 15.0,),
//                      Container(
//                        child: Text("${_contact.address}", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//
//              Card(
//                elevation: 2.0,
//                child: Container(
//                  margin: EdgeInsets.only(top: 15.0),
//                  width: double.maxFinite,
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceAround,
//                    children: <Widget>[
//                      Container(
//                        child: IconButton(
//                          splashColor: Colors.black12,
//                          icon: Icon(Icons.call),
//                          iconSize: 30.0,
//                          color: Colors.red,
//                          onPressed: (){
//                            callAction(_contact.phone);
//                          },
//                        ),
//                      ),
//                      Container(
//                        child: IconButton(
//                          splashColor: Colors.black12,
//                          icon: Icon(Icons.sms),
//                          iconSize: 30.0,
//                          color: Colors.red,
//                          onPressed: (){
//                            smsAction(_contact.phone);
//                          },
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//
//              Card(
//                elevation: 2.0,
//                child: Container(
//                  margin: EdgeInsets.only(top: 10.0),
//                  width: double.infinity,
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceAround,
//                    children: <Widget>[
//                      Container(
//                        child: IconButton(
//                          icon: Icon(Icons.mode_edit),
//                          iconSize: 30.0,
//                          color: Colors.red,
//                          splashColor: Colors.black12,
//                          onPressed: (){
//                            editContact(_contact.id);
//                          },
//                        ),
//                      ),
//                      Container(
//                        child: IconButton(
//                          icon: Icon(Icons.delete),
//                          iconSize: 30.0,
//                          color: Colors.red,
//                          splashColor: Colors.black12,
//                          onPressed: (){
//                            deleteContact(_contact.id);
//                          },
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ],
//        ),
//      ),
//    );
//  }
//}
