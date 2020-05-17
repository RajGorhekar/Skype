import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype/models/contact.dart';
import 'package:skype/provider/userProvider.dart';
import 'package:skype/resources/chatMethods.dart';
import 'package:skype/screens/pageviews/widgets/contactView.dart';
import 'package:skype/screens/pageviews/widgets/quietBox.dart';
import 'package:skype/screens/pageviews/widgets/userCircle.dart';
import 'package:skype/utils/universal_variables.dart';
import 'package:skype/widgets/appbar.dart';

class ChatListScreen extends StatelessWidget {
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
        title: UserCircle(),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/search_screen");
              }),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        centerTitle: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        floatingActionButton: NewChatBtn(),
        body: ChatListContainer());
  }
}

class NewChatBtn extends StatelessWidget {
  const NewChatBtn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          gradient: UniversalVariables.fabGradient,
          borderRadius: BorderRadius.circular(50)),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  ChatListContainer({Key key}) : super(key: key);
  final ChatMethods _chatMethods = ChatMethods();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(userId: userProvider.getUser.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);
                  return ContactView(contact : contact);
                },
              );
            }
            return Center(child : CircularProgressIndicator());
          }),
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
