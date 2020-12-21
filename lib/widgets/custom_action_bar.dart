import 'package:flutter/material.dart';
import 'package:kaim/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaim/screens/cart_page.dart';
import 'package:kaim/services/firebase_services.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitile;
  final bool hasBackground;

  CustomActionBar(
      {this.title, this.hasBackArrow, this.hasTitile, this.hasBackground});

  FirebaseServices _firebaseServices = FirebaseServices();

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle = hasTitile ?? true;
    bool _hasBackground = hasBackground ?? true;

    return Container(
      decoration: BoxDecoration(
          gradient: _hasBackground
              ? LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0),
                  ],
                  begin: Alignment(0, 0),
                  end: Alignment(0, 1),
                )
              : null),
      padding: EdgeInsets.only(top: 26, left: 24, right: 24, bottom: 42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage("assets/images/back.png"),
                  height: 18,
                  width: 18,
                  color: Colors.white,
                ),
              ),
            ),
          if (_hasTitle)
            Text(
              title ?? "Action Bar",
              style: Constants.boldHeading,
            ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartPage()));
            },
            child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: StreamBuilder(
                  stream: _usersRef
                      .doc(_firebaseServices.getUserId())
                      .collection("Cart")
                      .snapshots(),
                  builder: (context, snapshot) {
                    int _totalItems = 0;

                    if (snapshot.connectionState == ConnectionState.active) {
                      List _documents = snapshot.data.docs;
                      _totalItems = _documents.length;
                    }
                    return Text(
                      "$_totalItems" ?? "0",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
