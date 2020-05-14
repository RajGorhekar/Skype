import 'package:flutter/material.dart';
import 'package:skype/resources/firebase_repository.dart';
import 'package:skype/screens/home.dart';
import 'package:skype/screens/login.dart';
import 'package:skype/screens/searchScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/search_screen': (context) => SearchScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        body : FutureBuilder(
          future: _repository.getCurrentUser(),
          builder : (context,snapshot){
            if(snapshot.hasData){
              return HomeScreen();
            }else{
              return LoginScreen();
            }
          }
          )
      ),
    );
  }
}
