import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/widgets/components/custom_rect_tween.dart';
import 'package:flutter_todo_app/widgets/components/hero_diolog_route.dart';
import 'package:flutter_todo_app/widgets/search_delegate.dart';
import 'package:flutter_todo_app/widgets/task_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    allTasks = <Task>[];
    _localStorage = locator<LocalStorage>();
    _getAllTasksFromDb();
    super.initState();
  }

  final String _heroAddTodo = 'add-todo-hero';

  Color mainColor = const Color.fromRGBO(30, 31, 40, 1);
  Color redThemeColor = const Color.fromRGBO(239, 54, 81, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Görevler",
          style: TextStyle(
              color: Color.fromRGBO(30, 31, 40, 1),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                _showSearcPage();
              },
              icon: const Icon(
                Icons.search_sharp,
                color: Color.fromRGBO(30, 31, 40, 1),
              )),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  HeroDialogRoute(
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            top: 16),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Hero(
                              tag: _heroAddTodo,
                              createRectTween: (begin, end) {
                                return CustomRectTween(
                                    begin: begin!, end: end!);
                              },
                              child: Material(
                                color: mainColor,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 3, color: redThemeColor),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          style: TextStyle(
                                              color: redThemeColor,
                                              fontSize: 18),
                                          autofocus: false,
                                          cursorColor: redThemeColor,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: mainColor,
                                            hintText: 'Yeni Görev',
                                            hintStyle: TextStyle(
                                                color: redThemeColor,
                                                fontWeight: FontWeight.bold),
                                            border: InputBorder.none,
                                          ),
                                          onSubmitted: (value) {
                                            Navigator.of(context).pop();
                                            DatePicker.showTimePicker(
                                              context,
                                              showSecondsColumn: false,
                                              locale: LocaleType.tr,
                                              onConfirm: (time) async {
                                                var newTask = Task.create(
                                                    name: value,
                                                    createdAt: time);
                                                allTasks.insert(0, newTask);
                                                await _localStorage.addTask(
                                                    task: newTask);
                                                setState(() {});
                                              },
                                              theme: DatePickerTheme(
                                                backgroundColor: mainColor,
                                                itemStyle: TextStyle(
                                                    color: redThemeColor),
                                                cancelStyle: TextStyle(
                                                    color: redThemeColor),
                                                doneStyle: TextStyle(
                                                    color: redThemeColor),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              child: Hero(
                tag: _heroAddTodo,
                createRectTween: (begin, end) {
                  return CustomRectTween(begin: begin!, end: end!);
                },
                child: const Icon(
                  Icons.add,
                  color: Color.fromRGBO(30, 31, 40, 1),
                ),
              ),
            ),
          ),
        ],
      ),
      body: allTasks.isNotEmpty
          ? ListView.builder(
              itemCount: allTasks.length,
              itemBuilder: (BuildContext context, int index) {
                var listItem = allTasks[index];
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
                  onDismissed: (direction) {
                    allTasks.removeAt(index);
                    _localStorage.deleteTask(task: listItem);
                    setState(() {});
                  },
                  child: TaskItem(task: listItem),
                );
              },
            )
          : const Center(
              child: Text(
                "Henüz bir görev yok",
                style: TextStyle(color: Color.fromRGBO(239, 54, 81, 1)),
              ),
            ),
    );
  }

  void _getAllTasksFromDb() async {
    allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearcPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTasks: allTasks));
    _getAllTasksFromDb();
  }
}
