import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:bookduetracker/provider/theme.dart';
import 'package:bookduetracker/helpers/database_helper.dart';
import 'package:bookduetracker/models/task_model.dart';
import 'package:bookduetracker/screens/add_task_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Task>>? _taskList;
  final DateFormat formatter = DateFormat('d');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask(Task task) {
    DateTime? date1 =
        DateTime(task.date!.year, task.date!.month, task.date!.day);
    DateTime? date2 = DateTime.now();
    final dif = date1.difference(date2).inDays;
    void _awaitForDay(BuildContext context) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddTaskScreen(
            updateTaskList: _updateTaskList,
            task: task,
          ),
        ),
      );
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () => _awaitForDay(context),
        child: Dismissible(
          key: UniqueKey(),
          background: Container(
            padding: const EdgeInsets.only(left: 15.0),
            alignment: Alignment.centerLeft,
            color: Colors.red[900],
            child: const Icon(
              Icons.delete_forever,
              color: Colors.black,
              size: 35.0,
            ),
          ),
          secondaryBackground: Container(
            padding: const EdgeInsets.only(right: 15.0),
            alignment: Alignment.centerRight,
            color: Colors.red[900],
            child: const Icon(
              Icons.delete_forever,
              color: Colors.black,
              size: 35.0,
            ),
          ),
          onDismissed: (direction) async {
            setState(() {
              DatabaseHelper.instance.deleteTask(task.id);
              _updateTaskList();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Deleted Successfully...!"),
                  action: SnackBarAction(
                    label: 'HIDE',
                    onPressed: () {},
                  ),
                ),
              );
            });
          },
          child: Card(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 8.0,
            margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(7.0, 5.0, 5.0, 5.0),
              height: 100.0,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        task.title!,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 2.0,
                    color: Colors.black,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 90.0,
                        color: Colors.black,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          task.date!.day.toString(),
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: (dif <= 3) ? Colors.red[900] : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Themechanger themechanger = Provider.of<Themechanger>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Center(
            child: Text(
              'Book Tracker',
              style: TextStyle(
                  color: Color(0xFF018786),
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0),
            ),
          ),
          leading: const SizedBox(
            width: 15,
          ),
          actions: [
            Icon(
              themechanger.getDarkMode() ? Icons.dark_mode : Icons.light_mode,
            ),
            Switch(
              activeColor: Theme.of(context).cardColor,
              value: themechanger.getDarkMode(),
              onChanged: (value) {
                setState(() {
                  themechanger.changeDarkMode(value);
                });
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).cardColor,
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddTaskScreen(updateTaskList: _updateTaskList),
              ),
            ),
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 35.0,
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 75.0),
              itemCount: 1 + (snapshot.data as List<Task>).length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15.0),
                            child: const Text(
                              'Hi There 👋,',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return _buildTask((snapshot.data as List<Task>)[index - 1]);
              },
            );
          },
        ),
      ),
    );
  }
}
