import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype/enum/userState.dart';
import 'package:skype/models/user.dart';
import 'package:skype/resources/authMethods.dart';
import 'package:skype/utils/utilities.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();
  OnlineDotIndicator({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.redAccent;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.yellow;
      }
    }

    return Align(
      alignment: Alignment.bottomRight,
        child: StreamBuilder<DocumentSnapshot>(
      stream: _authMethods.getUserStream(uid: uid),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        User user;

        if (snapshot.hasData && snapshot.data.data != null) {
          user = User.fromMap(snapshot.data.data);
        }
        return Container(
          height: 12,
          width: 12,
          margin: EdgeInsets.only(right: 2, top: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getColor(user?.state),
            border : Border.all(width : 1.5,
            color: Colors.black
            )
          ),
        );
      },
    ));
  }
}
