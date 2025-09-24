import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
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
              return SliverFillRemaining(
                child: Center(child: Text("No To-Do")),
              );
            } else {
              return SliverList.builder(
                itemCount: boxToDo.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Slidable(
                      key: ValueKey(boxToDo.getAt(index)),

                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(16),
                            onPressed: (key) {
                              boxToDo.deleteAt(index);
                            },
                            icon: FontAwesome.trash_can_solid,
                            backgroundColor: Colors.redAccent,
                          ),
                        ],
                      ),

                      child: MyToDoCard(text: boxToDo.getAt(index)),
                    ),
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
