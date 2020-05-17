import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String uid;
  Timestamp addedOn;

  Contact({this.uid,this.addedOn});

  Map toMap(Contact contact){
    var data = Map<String,dynamic>();
    data['contact_id'] = contact.uid;
    data['added_on'] = contact.addedOn;
    return data;
  }

  Contact.fromMap(Map<String,dynamic> mapdata){
    this.uid = mapdata['contact_id'];
    this.addedOn = mapdata['added_on'] ;
  }
}
