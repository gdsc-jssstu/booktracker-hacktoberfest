import 'dart:ui';
import 'package:bookduetracker/provider/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:bookduetracker/helpers/database_helper.dart';
import 'package:bookduetracker/models/task_model.dart';
import 'package:bookduetracker/screens/add_task_screen.dart';
import 'package:provider/provider.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Task>>? _taskList;
  // final DateFormat _dateFormatter = DateFormat('MM-dd-yyyy');
  final DateFormat formatter = DateFormat('d');
  String day = "";

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
    void _awaitForDay(BuildContext context) async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              AddTaskScreen(updateTaskList: _updateTaskList, task: task),
        ),
      );
      setState(() {
        day = result;
        // print(index);
      });
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            // ListTile(
            //   title: Text(
            //     task.title!,
            //     style: TextStyle(
            //         fontSize: 18,
            //         decoration: task.status == 0
            //             ? TextDecoration.none
            //             : TextDecoration.lineThrough),
            //   ),
            //   subtitle: Text(
            //     '${_dateFormatter.format(task.date!)} * ${task.priority}',
            //     style: TextStyle(
            //         fontSize: 15,
            //         decoration: task.status == 0
            //             ? TextDecoration.none
            //             : TextDecoration.lineThrough),
            //   ),
            //   trailing: Checkbox(
            //     onChanged: (value) {
            //       task.status = value! ? 1 : 0;
            //       DatabaseHelper.instance.updateTask(task);
            //       _updateTaskList();
            //     },
            //     activeColor: Theme.of(context).primaryColor,
            //     value: task.status == 1 ? true : false,
            //   ),
            //   onTap: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (_) => AddTaskScreen(
            //               updateTaskList: _updateTaskList, task: task))),
            // ),
            const Divider(),
            GestureDetector(
              onTap: () => _awaitForDay(context),
              child: Container(
                padding: const EdgeInsets.all(5.0),
                height: 100.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          task.title!,
                          style: const TextStyle(fontSize: 25.0),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 2.0,
                      color: Colors.black54,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 90.0,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            day.isEmpty ? formatter.format(task.date!) : day,
                            // formatter.format(task.date!),
                            // day,
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Themechanger themechanger = Provider.of<Themechanger>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: const Center(child: Text('Book Tracker')),
          leading: const SizedBox(
            width: 15,
          ),
          actions: [
            Icon(themechanger.getDarkMode()
                ? Icons.dark_mode
                : Icons.light_mode),
            Switch(
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
          // backgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddTaskScreen(updateTaskList: _updateTaskList),
              ),
            )
          },
          // child: const Icon(
          //   Icons.add,
          //   color: Colors.white,
          // ),
          child: Icon(
            Icons.add,
            color: Colors.green[900],
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

            // final int? completedTaskCount = (snapshot.data as List<Task>)
            //     .where((Task task) => task.status == 1)
            //     .toList()
            //     .length;

            return ListView.builder(
              // padding: const EdgeInsets.symmetric(vertical: 60.0),
              itemCount: 1 + (snapshot.data as List<Task>).length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: const Text(
                            'Hi There 👋,',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        // const Text(
                        //   'Books to be Returned',
                        //   style: TextStyle(
                        //       color: Color(0xFF018786),
                        //       fontSize: 32,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        // const SizedBox(
                        //   height: 10.0,
                        // ),
                        // Text(
                        //   '$completedTaskCount of ${(snapshot.data as List<Task>).length}',
                        //   style: const TextStyle(
                        //       color: Colors.grey,
                        //       fontSize: 15.0,
                        //       fontWeight: FontWeight.w600),
                        // )
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
