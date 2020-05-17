import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype/models/message.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;
  const LastMessageContainer({Key key, this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data.documents;
            if (docList.isNotEmpty) {
              Message message = Message.fromMap(docList.last.data);
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  message.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              );
            } else {
              return Text(
                "No Message",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              );
            }
          } else {
            return Text(
              "...",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            );
          }
        });
  }
}
