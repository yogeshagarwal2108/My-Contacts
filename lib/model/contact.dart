import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Contact{
  String _id;
  String _firstName;
  String _lastName;
  String _email;
  String _phone;
  String _address;
  String _photoUrl;


  Contact(this._firstName, this._lastName, this._email, this._phone, this._address, this._photoUrl);
  Contact.withId(this._id, this._firstName, this._lastName, this._email, this._phone, this._address, this._photoUrl);


  //custom getter
  String get id=> _id;
  String get firstName=> _firstName;
  String get lastName=> _lastName;
  String get email=> _email;
  String get phone=> _phone;
  String get address=> _address;
  String get photoUrl=> _photoUrl;

  //custom setter
  set firstName(String firstName){
    _firstName= firstName;
  }
  set lastName(String lastName){
    _lastName= lastName;
  }
  set email(String email){
    _email= email;
  }
  set phone(String phone){
    _phone= phone;
  }
  set address(String address){
    _address= address;
  }
  set photoUrl(String photoUrl){
    _photoUrl= photoUrl;
  }


  //convert json data to contact data
  Contact.fromSnapshot(DataSnapshot snapshot){
    _id= snapshot.key;
    _firstName= snapshot.value["firstName"];
    _lastName= snapshot.value["lastName"];
    _email= snapshot.value["email"];
    _phone= snapshot.value["phone"];
    _address= snapshot.value["address"];
    _photoUrl= snapshot.value["photoUrl"];
  }


  //convert contact data to json data
  Map<String, dynamic> toJson(){
    return {
      "id": _id,
      "firstName": _firstName,
      "lastName": _lastName,
      "email": _email,
      "phone": _phone,
      "address": address,
      "photoUrl": _photoUrl,
    };
  }

}










//import 'package:firebase_database/firebase_database.dart';
//
//class Contact{
//
//  String _id;
//  String _firstName;
//  String _lastName;
//  String _email;
//  String _phone;
//  String _address;
//  String _photoUrl;
//
//  Contact(this._firstName, this._lastName, this._phone, this._email, this._address, this._photoUrl);
//  Contact.withId(this._id, this._firstName, this._lastName, this._phone, this._email, this._address, this._photoUrl);
//
//
//  //custom getters
//  String get id=> this._id;
//  String get firstName=> this._firstName;
//  String get lastName=> this._lastName;
//  String get phone=> this._phone;
//  String get email=> this._email;
//  String get address=> this._address;
//  String get photoUrl=> this._photoUrl;
//
//  //custom setters
//  set firstName(String firstName){
//    this._firstName= firstName;
//  }
//  set lastName(String lastName){
//    this._lastName= lastName;
//  }
//  set phone(String phone){
//    this._phone= phone;
//  }
//  set email(String email){
//    this._email= email;
//  }
//  set address(String address){
//    this._address= address;
//  }
//  set photoUrl(String photoUrl){
//    this._photoUrl= photoUrl;
//  }
//
//
//  //convert json data (snapshot) to contact data
//  Contact.fromSnapshot(DataSnapshot snapshot){
//    this._id= snapshot.key;
//    this._firstName= snapshot.value["firstName"];
//    this._lastName= snapshot.value["lastName"];
//    this._phone= snapshot.value["phone"];
//    this._email= snapshot.value["email"];
//    this._address= snapshot.value["address"];
//    this._photoUrl= snapshot.value["photoUrl"];
//  }
//
//  //convert contact data to json data (snapshot)
//  Map<String, dynamic> toJson(){
//    return {
//      "firstName": _firstName,
//      "lastName": _lastName,
//      "phone": _phone,
//      "email": _email,
//      "address": _address,
//      "photoUrl": _photoUrl,
//    };
//  }
//}