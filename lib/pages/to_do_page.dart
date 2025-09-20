import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:niyama/models/boxes.dart';
import 'package:niyama/widgets/my_to_do_card.dart';

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
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
          ),
        ),

        ValueListenableBuilder(
          valueListenable: boxToDo.listenable(),
          builder: (context, boxToDo, child) {
            if (boxToDo.length <= 0) {
              return SliverList.list(
                children: [Center(child: Text("No To-Do"))],
              );
            } else {
              return SliverList.builder(
                itemCount: boxToDo.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(boxToDo.getAt(index)),
                    onDismissed: (direction) {
                      boxToDo.deleteAt(index);
                    },
                    child: MyToDoCard(text: boxToDo.getAt(index)),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
