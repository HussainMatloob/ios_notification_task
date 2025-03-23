import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static Future<void> uploadFileOnStorge(File file, String fileName) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child("uploads/$fileName");
      await ref.putFile(file);
    } on FirebaseException catch (e) {
      throw Exception("Database error: ${e.message}");
    } on TimeoutException {
      throw "Request timed out. Please check your internet connection.";
    } on SocketException {
      throw "Network issue detected. Please try again.";
    } catch (e) {
      throw "Something went wrong: ${e.toString()}";
    }
  }
}
