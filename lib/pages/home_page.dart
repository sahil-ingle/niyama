import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 160,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("Hello, Sahil"),
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
          ),
        ),
      ],
    );
  }
}
