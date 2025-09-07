import 'package:flutter/material.dart';
import 'package:niyama/pages/habit_page.dart';
import 'package:niyama/pages/home_page.dart';
import 'package:niyama/pages/settings_page.dart';
import 'package:niyama/pages/to_do_page.dart';
import 'package:niyama/widgets/my_nav_bar.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;

  void onItemSelect(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> selectedPage = [
    HomePage(),
    HabitPage(),
    ToDoPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(title: Text("Hello, Sahil!")),
          ),
          SliverList.list(children: [selectedPage.elementAt(_selectedIndex)]),
        ],
      ),

      bottomNavigationBar: MyNavBar(
        currentIndex: _selectedIndex,
        onTap: onItemSelect,
      ),
    );
  }
}
