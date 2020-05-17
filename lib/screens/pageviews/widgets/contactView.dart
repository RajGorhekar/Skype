import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype/models/contact.dart';
import 'package:skype/models/user.dart';
import 'package:skype/provider/userProvider.dart';
import 'package:skype/resources/authMethods.dart';
import 'package:skype/resources/chatMethods.dart';
import 'package:skype/screens/chatScreens/chatScreen.dart';
import 'package:skype/screens/pageviews/widgets/lastMessage.dart';
import 'package:skype/screens/pageviews/widgets/onlineDotIndicator.dart';
import 'package:skype/widgets/cachedImage.dart';
import 'package:skype/widgets/customTile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods authMethods = AuthMethods();
  ContactView({Key key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          )),
      title: Text(
        (contact != null ? contact.name : null) != null ? contact.name : "..",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
             OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}
// return CustomTile(
//             mini: false,
//             onTap: () {},
//             title: Text(
//               "The CS Guy",
//               style: TextStyle(
//                   color: Colors.white, fontFamily: "Arial", fontSize: 19),
//             ),
//             subtitle: Text(
//               "Hello",
//               style: TextStyle(
//                 color: UniversalVariables.greyColor,
//                 fontSize: 14,
//               ),
//             ),
//             leading: Container(
//               constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
//               child: Stack(
//                 children: <Widget>[
//                   CircleAvatar(
//                     maxRadius: 30,
//                     backgroundColor: Colors.grey,
//                     backgroundImage: NetworkImage(
//                         "https://yt3.ggpht.com/a/AGF-l7_zT8BuWwHTymaQaBptCy7WrsOD72gYGp-puw=s900-c-k-c0xffffffff-no-rj-mo"),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: Container(
//                       height: 13,
//                       width: 13,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                               color: UniversalVariables.blackColor, width: 2),
//                           color: UniversalVariables.onlineDotColor),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
