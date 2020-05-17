import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skype/models/contact.dart';
import 'package:skype/models/message.dart';
import 'package:skype/models/user.dart';

class ChatMethods {
  static final Firestore firestore = Firestore.instance;

  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();
    await firestore
        .collection("messages")
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(
      senderId: message.senderId,
      receiverId: message.receiverId,
    );

    await firestore
        .collection("messages")
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();
    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  DocumentReference getContactsDocument({String of, String forContact}) =>
      firestore
          .collection('users')
          .document(of)
          .collection('contact')
          .document(forContact);

  Future<void> addToSenderContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();
    if (!senderSnapshot.exists) {
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );
      var receiverMap = receiverContact.toMap(receiverContact);
      await getContactsDocument(of: senderId, forContact: receiverId)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .setData(senderMap);
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    var map = message.toImageMap();

    await firestore
        .collection('messages')
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    firestore
        .collection('messages')
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => firestore
      .collection('users')
      .document(userId)
      .collection('contact')
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    String senderId,
    String receiverId,
  }) =>
      firestore
          .collection('messages')
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}
