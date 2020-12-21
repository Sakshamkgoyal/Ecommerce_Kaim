import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  BottomTabs({this.selectedTab, this.tabPressed});
  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 0;


  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab ?? 0;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1.0,
              blurRadius: 30.0,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabBtn(
            imagePath: "assets/images/home.png",
            selected: _selectedTab == 0 ? true : false,
            onPressed: (){
              setState(() {
                widget.tabPressed(0);
              });
            },
          ),
          BottomTabBtn(
            imagePath: "assets/images/search.png",
            selected: _selectedTab == 1 ? true : false,
            onPressed: (){
              setState(() {
                widget.tabPressed(1);
              });
            },
          ),
          BottomTabBtn(
            imagePath: "assets/images/bookmark.png",
            selected: _selectedTab == 2 ? true : false,
            onPressed: (){
              setState(() {
                widget.tabPressed(2);
              });
            },
          ),
          BottomTabBtn(
            imagePath: "assets/images/exit.png",
            selected: _selectedTab == 3 ? true : false,
            onPressed: (){
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final String imagePath;
  final bool selected;
  final Function onPressed;

  BottomTabBtn({this.imagePath, this.selected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
          color: _selected ? Theme.of(context).accentColor : Colors.transparent,
          width: 2,
        ))),
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Image(
          color: _selected ? Theme.of(context).accentColor : Colors.black,
          height: 24,
          width: 24,
          image: AssetImage(
            imagePath ?? "assets/images/home.png",
          ),
        ),
      ),
    );
  }
}
