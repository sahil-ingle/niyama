import 'package:flutter/material.dart';

class MyNavBar extends StatefulWidget {
  const MyNavBar({required this.currentIndex, required this.onTap, super.key});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: "Habits"),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: "To-Do",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],

        type: BottomNavigationBarType.fixed,

        elevation: 4,

        currentIndex: widget.currentIndex,
        onTap: widget.onTap,

        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
