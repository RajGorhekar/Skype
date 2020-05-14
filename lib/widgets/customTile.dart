import 'package:flutter/material.dart';
import 'package:skype/utils/universal_variables.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  const CustomTile(
      {Key key,
      @required this.leading,
      @required this.title,
      this.icon,
      @required this.subtitle,
      this.trailing,
      this.margin = const EdgeInsets.all(0),
      this.mini = true,
      this.onTap,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          margin: EdgeInsets.only(left: mini ? 3 : 10),
          padding: EdgeInsets.symmetric(vertical: mini ? 3 : 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: 1, color: UniversalVariables.separatorColor),
            ),
          ),
          child: GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Container(
              child: Row(
                children: <Widget>[
                  leading,
                  SizedBox(
                    width :10
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: mini ? 10 : 10),
                        padding: EdgeInsets.symmetric(vertical: mini ? 3 : 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                title,
                                SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    icon ?? Container(),
                                    subtitle,
                                  ],
                                )
                              ],
                            ),
                            trailing ?? Container(),
                          ],
                        )),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
