import 'dart:math';
import 'package:firebase_login/Screens/add_contact.dart';
import 'package:firebase_login/Screens/view_contact.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/contact.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DatabaseReference _databaseReference= FirebaseDatabase.instance.reference();

  moveToAddContact(){
    Navigator.push(context, MaterialPageRoute(
      builder: (context)=> AddContact(),
    ));
  }
  moveToViewContact(id){
    Navigator.push(context, MaterialPageRoute(
      builder: (context)=> ViewContact(id),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact App"),
        backgroundColor: Colors.indigoAccent,
      ),

      body: Container(
        padding: EdgeInsets.all(6.0),
        child: FirebaseAnimatedList(
          query: _databaseReference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int i){
            return GestureDetector(
              onTap: (){
                moveToViewContact(snapshot.key);
              },
              child: Card(
                color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.indigo),
                ),
                child: Container(
                  padding: EdgeInsets.all(7.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: snapshot.value["photoUrl"]== "empty" ? AssetImage("assets/logo.png") : NetworkImage(snapshot.value["photoUrl"]),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${snapshot.value["firstName"]} ${snapshot.value["lastName"]}", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                              Container( height: 10.0, ),
                              Text("${snapshot.value["phone"]}"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
        onPressed: (){
          moveToAddContact();
        },
      ),
    );
  }
}