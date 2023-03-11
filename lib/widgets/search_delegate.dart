import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/widgets/task_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;
  CustomSearchDelegate({required this.allTasks});
  Color mainColor = const Color.fromRGBO(30, 31, 40, 1);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: Icon(
        Icons.arrow_back_ios,
        color: mainColor,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks
        .where(
          (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (BuildContext context, int index) {
              var listItem = filteredList[index];
              return Dismissible(
                background: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Color.fromRGBO(239, 54, 81, 1),
                        size: 32,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Görevi sil",
                        style: TextStyle(
                            color: Color.fromRGBO(239, 54, 81, 1),
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                key: Key(listItem.id),
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await locator<LocalStorage>().deleteTask(task: listItem);
                },
                child: TaskItem(task: listItem),
              );
            },
          )
        : const Center();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
