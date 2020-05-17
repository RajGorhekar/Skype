import 'package:flutter/material.dart';
import 'package:skype/models/call.dart';
import 'package:skype/provider/userProvider.dart';
import 'package:skype/resources/callMethods.dart';
import 'package:provider/provider.dart';
import 'package:skype/screens/callScreens/pickupScreen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();
  PickupLayout({Key key, this.scaffold}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
     final UserProvider userProvider = Provider.of<UserProvider>(context);
    return (userProvider != null && userProvider.getUser != null) ? StreamBuilder(
      stream: callMethods.callStream(uid : userProvider.getUser.uid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
        if (snapshot.hasData && snapshot.data.data != null) {
                Call call = Call.fromMap(snapshot.data.data);

                if (!call.hasDialled) {
                  return PickupScreen(call: call);
                }
              }
              return scaffold;
       },
      
      
    ):Scaffold(
      body : Center(child: CircularProgressIndicator(),)
    );
  }
}