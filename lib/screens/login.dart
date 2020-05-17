import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype/resources/authMethods.dart';
import 'package:skype/screens/home.dart';
import 'package:skype/utils/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthMethods authMethods = AuthMethods();
  String loginVal = 'LOGIN';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Center(
        child: loginButton(),
      ),
    );
  }

  Widget loginButton() {
    return Shimmer.fromColors(
      child: FlatButton(
        onPressed: () => performLogin(),
        shape: RoundedRectangleBorder(borderRadius : BorderRadius.circular(10)),
        child: Text(
          loginVal,
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        )), 
      baseColor:  Colors.white, 
      highlightColor: UniversalVariables.senderColor);
  }

  void performLogin(){
    setState(() {
      loginVal = 'Please Wait ...' ;
    });
    authMethods.signIn().then((FirebaseUser user){
      if(user != null){
        authMethods.authenticateUser(user).then((isNewUser){
          if(isNewUser){
             authMethods.addDataToDb(user).then((value){
               loginVal = 'LOGIN';
               Navigator.push(context, MaterialPageRoute(builder : (context){
                return HomeScreen();
               }));
             });
          }else{
            loginVal = 'LOGIN';
            Navigator.push(context, MaterialPageRoute(builder : (context){
                return HomeScreen();
               }));
          }
        });
      }else{
        loginVal = 'LOGIN';
        print('There was an Error');
      }
    });
  }
}
