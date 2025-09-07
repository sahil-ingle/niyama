import 'package:flutter/material.dart';
import 'package:niyama/widgets/my_todo_card.dart';

class ToDoPage extends StatelessWidget {
  const ToDoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [MyTodoCard()]);
  }
}
