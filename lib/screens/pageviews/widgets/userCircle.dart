import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype/provider/userProvider.dart';
import 'package:skype/screens/pageviews/widgets/userDetailContainer.dart';
import 'package:skype/utils/universal_variables.dart';
import 'package:skype/utils/utilities.dart';

class UserCircle extends StatelessWidget {
  UserCircle({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
  final UserProvider userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: () => showModalBottomSheet(context: context, 
      builder: (context){
        return UserDetailsContainer();
      },
      backgroundColor: UniversalVariables.blackColor,
      isScrollControlled: true,
      ),
          child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: UniversalVariables.blackColor,
          shape: BoxShape.circle,
          border: Border.all(color: UniversalVariables.separatorColor, width: 1),
        ),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: Text(
                  Utils.getInitials(userProvider.getUser.name),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: UniversalVariables.lightBlueColor,
                    fontSize: 18,
                  ),
                )),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: UniversalVariables.blackColor, width: 2),
                    color: UniversalVariables.onlineDotColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}