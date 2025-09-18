import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
              "Settings",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
          ),
        ),
      ],
    );
  }
}
