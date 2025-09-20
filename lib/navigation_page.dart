import 'package:flutter/material.dart';
import 'package:niyama/models/boxes.dart';
import 'package:niyama/pages/habit_page.dart';
import 'package:niyama/pages/home_page.dart';
import 'package:niyama/pages/settings_page.dart';
import 'package:niyama/pages/to_do_page.dart';
import 'package:niyama/widgets/habit_add_sheet.dart';
import 'package:niyama/widgets/my_nav_bar.dart';
import 'package:niyama/widgets/my_text_field.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  final _toDoController = TextEditingController();

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

  void addNewToDo() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Add To Do"),
        content: MyTextField(
          nameController: _toDoController,
          hintText: "To Do",
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              final enteredName = _toDoController.text.trim();
              if (enteredName.isNotEmpty) {
                boxToDo.put('key_${DateTime.now()}', enteredName);
                _toDoController.clear();

                Navigator.pop(ctx);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter a valid To do")),
                );
              }
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _toDoController.dispose();
    super.dispose();
  }

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
