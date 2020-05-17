import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype/models/user.dart';
import 'package:skype/provider/userProvider.dart';
import 'package:skype/resources/authMethods.dart';
import 'package:skype/screens/login.dart';
import 'package:skype/widgets/appbar.dart';
import 'package:skype/widgets/cachedImage.dart';

final AuthMethods authMethods = AuthMethods();

class UserDetailsContainer extends StatelessWidget {
  const UserDetailsContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    signOut() async {
      final bool isLoggedOut = await authMethods.signOut();
      if (isLoggedOut) {
        
        // authMethods.setUserState(
        //   userId: userProvider.getUser.uid,
        //   userState: UserState.Offline,
        // );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          CustomAppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.maybePop(context)),
            centerTitle: true,
            title: ShimmeringLogo(),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => signOut(),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ))
            ],
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  const UserDetailsBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          CachedImage(
            user.profilePhoto,
            isRound: true,
            radius: 50,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(user.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white)),
              SizedBox(height: 10),
              Text(
                user.email,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 60,
        child: Stack(
          children: <Widget>[
            Image.asset(
              "assets/icon.png",
              height: 60,
            ),
            Shimmer.fromColors(
              baseColor: Colors.transparent,
              highlightColor: Colors.cyanAccent[100],
              child: Image.asset(
                "assets/icon.png",
                height: 60,
              ),
              period: Duration(seconds: 2),
            ),
          ],
        ));
  }
}
