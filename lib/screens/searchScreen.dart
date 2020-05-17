import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:skype/models/user.dart';
import 'package:skype/resources/authMethods.dart';
import 'package:skype/screens/chatScreens/chatScreen.dart';
import 'package:skype/utils/universal_variables.dart';
import 'package:skype/widgets/customTile.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<User> userList;
  String query = '';
  TextEditingController textEditingController = TextEditingController();
  AuthMethods authMethods = AuthMethods();

  @override
  void initState() {
    super.initState();
    authMethods.getCurrentUser().then((user) {
      authMethods.fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  Widget searchAppBar(context) {
    return GradientAppBar(
        backgroundColorStart: UniversalVariables.gradientColorStart,
        backgroundColorEnd: UniversalVariables.gradientColorEnd,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical : 8 , horizontal: 20),
            child: TextField(
                controller: textEditingController,
                onChanged: (val) {
                  setState(() {
                    query = val;
                  });
                },
                cursorColor: UniversalVariables.blackColor,
                autofocus: true,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 35,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Color(0x88ffffff),
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback(
                              (_) => textEditingController.clear());
                        }))),
          ),
        ));
  }

  Widget buildSuggestions(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList.where(
            (User user) =>
                (user.username.toLowerCase().contains(query.toLowerCase()) ||
                    user.name.toLowerCase().contains(query.toLowerCase())),
          ).toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          User searchedUser = User(
              uid: suggestionList[index].uid,
              profilePhoto: suggestionList[index].profilePhoto,
              name: suggestionList[index].name,
              username: suggestionList[index].username);
          return CustomTile(
            mini: false,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(receiver : searchedUser)));
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(searchedUser.profilePhoto),
              backgroundColor: Colors.grey,
            ),
            title: Text(
              searchedUser.username,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              searchedUser.name,
              style: TextStyle(color: UniversalVariables.greyColor),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: searchAppBar(context),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: buildSuggestions(query)));
  }
}
