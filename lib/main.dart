import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype/provider/imageUploadProvider.dart';
import 'package:skype/provider/userProvider.dart';
import 'package:skype/resources/authMethods.dart';
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
  final AuthMethods authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImageUploadProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
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
            body: FutureBuilder(
                future: authMethods.getCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HomeScreen();
                  } else {
                    return LoginScreen();
                  }
                })),
      ),
    );
  }
}
