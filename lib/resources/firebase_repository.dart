import 'package:firebase_auth/firebase_auth.dart';
import 'package:skype/models/message.dart';
import 'package:skype/models/user.dart';
import 'package:skype/resources/firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();
  
  Future<FirebaseUser> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(FirebaseUser user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb(FirebaseUser user) =>
      _firebaseMethods.addDataToDb(user);

   Future<void> signOut() => _firebaseMethods.signOut();

   Future<List<User>> fetchAllUsers(FirebaseUser user) => _firebaseMethods.fetchAllUsers(user);

    Future<void> addMessageToDb( Message message, User sender, User receiver) => _firebaseMethods.addMessageToDb(message, sender, receiver);
}
