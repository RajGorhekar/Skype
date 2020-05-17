import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skype/enum/viewState.dart';
import 'package:skype/models/message.dart';
import 'package:skype/models/user.dart';
import 'package:skype/provider/imageUploadProvider.dart';
import 'package:skype/resources/authMethods.dart';
import 'package:skype/resources/chatMethods.dart';
import 'package:skype/resources/storageMethods.dart';
import 'package:skype/utils/callUtilities.dart';
import 'package:skype/utils/permissions.dart';
import 'package:skype/utils/universal_variables.dart';
import 'package:skype/utils/utilities.dart';
import 'package:skype/widgets/appbar.dart';
import 'package:skype/widgets/cachedImage.dart';
import 'package:skype/widgets/customTile.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;
  const ChatScreen({Key key, this.receiver}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  bool isWriting = false;
  bool showEmojiPicker = false;
  User sender;
  String _currentUserId;
  AuthMethods authMethods = AuthMethods();
  StorageMethods storageMethods = StorageMethods();
  ChatMethods chatMethods = ChatMethods();
  ScrollController _listController = ScrollController();
  FocusNode textfieldFocus = FocusNode();
  ImageUploadProvider _imageUploadProvider;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender = User(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
    });
  }

  showKeyboard() => textfieldFocus.requestFocus();

  hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          _imageUploadProvider.getViewState == ViewState.LOADING
              ? Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                )
              : Container(),
          chatControls(),
          showEmojiPicker ? Container(child: emojiContainer()) : Container()
        ],
      ),
    );
  }

  Widget emojiContainer() {
    return EmojiPicker(
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });
        textFieldController.text = textFieldController.text + emoji.emoji;
      },
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 4,
      columns: 7,
      recommendKeywords: ['face', 'happy', 'party', 'sad'],
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 10,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return ListView(
              children: <Widget>[
                Divider(
                  color: UniversalVariables.separatorColor,
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.close,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Text(
                      "Content and tools",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ModalTile(
                    title: "Media",
                    subtitle: "Share Photos and Video",
                    icon: Icons.image,
                    onTap: () {
                      pickImage(source: ImageSource.gallery);
                    }),
                ModalTile(
                    title: "File", subtitle: "Share files", icon: Icons.tab),
                ModalTile(
                    title: "Contact",
                    subtitle: "Share contacts",
                    icon: Icons.contacts),
                ModalTile(
                    title: "Location",
                    subtitle: "Share a location",
                    icon: Icons.add_location),
                ModalTile(
                    title: "Schedule Call",
                    subtitle: "Arrange a skype call and get reminders",
                    icon: Icons.schedule),
                ModalTile(
                    title: "Create Poll",
                    subtitle: "Share polls",
                    icon: Icons.poll)
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  gradient: UniversalVariables.fabGradient,
                  shape: BoxShape.circle),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Stack(
              children: <Widget>[
                TextField(
                  onTap: () => hideEmojiContainer(),
                  controller: textFieldController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    hintStyle: TextStyle(
                      color: UniversalVariables.greyColor,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: UniversalVariables.separatorColor,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.face),
                      onPressed: () async{
                        if (!showEmojiPicker) {
                          hideKeyboard();
                          await Future.delayed(const Duration(milliseconds: 10));
                          showEmojiContainer();
                        } else {
                          hideEmojiContainer();
                          showKeyboard();
                        }
                      }),
                )
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  onTap: () => pickImage(source: ImageSource.camera),
                  child: Icon(Icons.camera_alt)),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 22,
                      ),
                      onPressed: () => sendMessage()))
              : Container()
        ],
      ),
    );
  }

  sendMessage() {
    var text = textFieldController.text;
    Message message = Message(
      receiverId: widget.receiver.uid,
      senderId: sender.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
    );
    setState(() {
      isWriting = false;
    });
    textFieldController.clear();
    chatMethods.addMessageToDb(message, sender, widget.receiver);
  }

  pickImage({@required ImageSource source}) async {
    _imageUploadProvider.setToLoading();
    File selectedImage = await Utils.pickImage(source,context,_imageUploadProvider);
    storageMethods.uploadImage(
        selectedImage,
        widget.receiver.uid,
        _currentUserId,
        _imageUploadProvider);
  }

  Widget messageList() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(_currentUserId)
            .collection(widget.receiver.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator());
          } else {
            // SchedulerBinding.instance.addPostFrameCallback((_) {
            //   _listController.animateTo(_listController.position.minScrollExtent, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
            // });

            return ListView.builder(
                controller: _listController,
                itemCount: snapshot.data.documents.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return chatItem(snapshot.data.documents[index]);
                });
          }
        });
  }

  Widget chatItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      alignment: _message.senderId == _currentUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: _message.senderId == _currentUserId
          ? senderLayout(_message)
          : receiverLayout(_message),
    );
  }

  getMessage(Message message) {
    return message.type != 'image'
        ? Text(
            message.message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          )
        : message.photoUrl != null
            ? CachedImage(message.photoUrl,height: 200,width: 150,radius : 10)
            : Text("Url was null");
  }

  Widget senderLayout(message) {
    Radius r = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 5,right : 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        gradient: message.type != 'image' ? UniversalVariables.fabGradient :null,
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: r,
          topRight: r,
          bottomLeft: r,
        ),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: getMessage(message)),
    );
  }

  Widget receiverLayout(Message message) {
    Radius r = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 5 ,left : 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: r,
          topRight: r,
          bottomRight: r,
        ),
      ),
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: getMessage(message)),
    );
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      title: Text(widget.receiver.name),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () async {await Permissions.cameraAndMicrophonePermissionsGranted()?
            CallUtils.dial(
              from : sender,
              to : widget.receiver,
              context: context
            ):{};
          },
        ),
        IconButton(
          icon: Icon(
            Icons.phone,
          ),
          onPressed: () {},
        )
      ],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile(
      {Key key,
      @required this.title,
      @required this.subtitle,
      @required this.icon,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: CustomTile(
          onTap: onTap,
          mini: false,
          leading: Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(10),
            child: Icon(icon, color: UniversalVariables.greyColor, size: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: UniversalVariables.receiverColor,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: UniversalVariables.greyColor,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: UniversalVariables.greyColor,
              fontSize: 14,
            ),
          ),
        ));
  }
}
