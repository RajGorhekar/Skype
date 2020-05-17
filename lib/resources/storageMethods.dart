import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:skype/models/user.dart';
import 'package:skype/provider/imageUploadProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skype/resources/chatMethods.dart';

class StorageMethods {
  static final Firestore firestore = Firestore.instance;
  StorageReference _storageReference;
  User user = User();
  final ChatMethods chatMethods = ChatMethods();

  Future<String> uploadImageToDb(File imageFile) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void uploadImage(
    File image,
    String receiverId,
    String senderId,
    ImageUploadProvider imageUploadProvider,
  ) async {
    imageUploadProvider.setToLoading();
    String url = await uploadImageToDb(image);
    chatMethods.setImageMsg(url, receiverId, senderId);
    imageUploadProvider.setToIdle();
  }
}
