import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/blocs/task/task_bloc.dart';
import 'package:task_management_app/models/task_model.dart';

import '../widgets/app_widget.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    context.read<TaskBloc>().add(FetchTasksEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final incompleteTasks = state.tasks
                .where((task) => task.status != 'Đã hoàn thành')
                .toList();
            final completedTasks = state.tasks
                .where((task) => task.status == 'Đã hoàn thành')
                .toList();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Chưa hoàn thành", style: TextStyle(fontSize: 16)),
                  Expanded(child: _buildTaskList(tasks: incompleteTasks)),
                  Text("Đã hoàn thành", style: TextStyle(fontSize: 16)),
                  Expanded(child: _buildTaskList(tasks: completedTasks)),
                ],
              ),
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Không có công việc nào.'));
          }
        },
      ),
    );
  }

  Widget _buildTaskList({required List<TaskModel> tasks}) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItem(
          taskId: task.id,
          text: task.name,
          isCompleted: true,
          date: task.deadline,
          description: task.description,
          priority: task.priority,
          flagColor: task.priority == 'Cao'
              ? Colors.red
              : task.priority == 'Vừa'
                  ? Colors.yellow
                  : task.priority == 'Thấp'
                      ? Colors.blue
                      : Colors.white,
        );
      },
    );
  }
}
