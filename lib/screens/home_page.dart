import 'package:flutter/material.dart';
import 'package:kaim/tabs/home_tab.dart';
import 'package:kaim/tabs/save_tab.dart';
import 'package:kaim/tabs/search_tab.dart';
import 'package:kaim/widgets/bottom_tabs.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController _tabsPageController;

  int _selectedTabValue;

  @override
  void initState() {
    _tabsPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Expanded(
                child: PageView(
                  controller: _tabsPageController,
                  onPageChanged: (num){
                    setState(() {
                      _selectedTabValue = num;
                    });
                  },
                  children: [
                    HomeTab(),
                    SearchTab(),
                    SavedTab(),
                  ],
                ),
              ),
            ),
            BottomTabs(
              selectedTab: _selectedTabValue,
              tabPressed: (num){
                setState(() {
                  _tabsPageController.animateToPage(num, duration: Duration(milliseconds: 300), curve: Curves.easeOutCubic);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
