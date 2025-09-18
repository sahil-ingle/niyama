import 'package:flutter/material.dart';
import 'package:niyama/pages/habit_page.dart';
import 'package:niyama/pages/home_page.dart';
import 'package:niyama/pages/settings_page.dart';
import 'package:niyama/pages/to_do_page.dart';
import 'package:niyama/widgets/habit_add_sheet.dart';
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

  void addNewToDo() {}

  void addNewHabit() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: 52, left: 20, right: 20, top: 52),
          child: HabitAddSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedPage[_selectedIndex],

      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: addNewHabit,
              tooltip: "New Habit",
              child: Icon(Icons.add),
            )
          : _selectedIndex == 2
          ? FloatingActionButton(
              onPressed: addNewToDo,
              tooltip: "New To-Do",
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : null,

      bottomNavigationBar: MyNavBar(
        currentIndex: _selectedIndex,
        onTap: onItemSelect,
      ),
    );
  }
}
