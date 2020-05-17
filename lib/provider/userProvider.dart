
import 'package:flutter/widgets.dart';
import 'package:skype/models/user.dart';
import 'package:skype/resources/authMethods.dart';

class UserProvider with ChangeNotifier {
  User _user;
  final AuthMethods authMethods = AuthMethods();

  User get getUser => _user;

  Future<void> refreshUser() async {
    User user = await authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

}