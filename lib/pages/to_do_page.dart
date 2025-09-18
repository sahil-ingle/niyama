import 'package:flutter/material.dart';

class ToDoPage extends StatelessWidget {
  const ToDoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 160,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "To-Do",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
          ),
        ),
      ],
    );
  }
}
