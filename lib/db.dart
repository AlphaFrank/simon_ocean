import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

Future<Map<String, dynamic>?> getEvents() async {
  Map<String, dynamic>? data;
  
  await FirebaseFirestore.instance
      .collection("ocean_cleaning")
      .doc('events2')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      data = documentSnapshot.data() as Map<String, dynamic>?;
    } else {
      print('Document not exist.');
    }
  });
  return data;

}

Future<Map<String, dynamic>?> getReport() async {
  Map<String, dynamic>? data;

  await FirebaseFirestore.instance
      .collection("ocean_cleaning")
      .doc('report')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          data = documentSnapshot.data() as Map<String, dynamic>?;
        } else {
          print('document does not exist on the database');
        }

  });
  return data;
}

Future<bool> addReport(Map data, date) async {
  FirebaseFirestore.instance
      .collection("ocean_cleaning")
      .doc('report')
      .set({date: data}, SetOptions(merge: true));
  return true;
}

UploadTask? uploadFile(String destination, File file) {
  try {
    final ref = FirebaseStorage.instance.ref(destination);
    return ref.putFile(file);
  } on FirebaseException catch (e) {
    print("===== error ========");
    print(e);
    return null;
  }
}
  
  

    
    