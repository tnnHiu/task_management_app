import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/pages/widgets/app_widget.dart';

import '../../blocs/task/task_bloc.dart';
import '../event_pages/add_event_page.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage(BuildContext context, {super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedPriority;
  String? _selectedStatus;
  DateTime? _selectedDate;

  final List<Map<String, dynamic>> _priorityLevels = [
    {'label': 'Cao', 'color': Colors.red},
    {'label': 'Vừa', 'color': Colors.yellow},
    {'label': 'Thấp', 'color': Colors.blue},
    {'label': 'Không ưu tiên', 'color': Colors.grey},
  ];

  final List<String> _statusOptions = ['Chưa hoàn thành', 'Đã hoàn thành'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242424),
      appBar: AppBar(
        backgroundColor: Color(0xFF353535),
        centerTitle: true,
        title: Text(
          'Thêm nhiệm vụ',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        actions: [
          Tooltip(
            message: 'Chuyển sang sự kiện',
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEventPage()),
                );
              },
              icon: Icon(Icons.arrow_right,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: BlocProvider(
        create: (context) => TaskBloc(),
        // value: BlocProvider.of<TaskBloc>(context),
        child: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                AppTextField(
                  hintText: "Tên nhiệm vụ",
                  controller: _nameController,
                ),
                const SizedBox(height: 16.0),
                AppTextField(
                  hintText: "Mô tả",
                  controller: _descriptionController,
                  maxLines: 2,
                ),
                const SizedBox(height: 16.0),
                _buildDropDownButtonFormField(
                  value: _selectedPriority,
                  hint: "Chọn Mức Độ Ưu Tiên",
                  items: _priorityLevels.map((priority) {
                    return DropdownMenuItem<String>(
                      value: priority['label'],
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            color: priority['color'],
                          ),
                          const SizedBox(width: 8),
                          Text(priority['label']),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                _buildDropDownButtonFormField(
                  value: _selectedStatus,
                  hint: "Chọn Trạng Thái",
                  items: _statusOptions
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                _buildSelectDateForm(context),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _addTask(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 196, 131, 9),
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Thêm Công Việc'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  DropdownButtonFormField _buildDropDownButtonFormField({
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF353535),
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: const Color(0xFF353535),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      hint: Text(hint, style: const TextStyle(color: Color(0xFF818181))),
      items: items,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
    );
  }

  TextFormField _buildSelectDateForm(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: _selectedDate == null
              ? 'Chọn Ngày'
              : DateFormat('yyyy-MM-dd').format(_selectedDate!),
          suffixIcon: const Icon(Icons.calendar_today),
          filled: true,
          fillColor: const Color(0xFF353535),
          hintStyle: const TextStyle(color: Color(0xFFFAA80C)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          )),
      onTap: () => _selectDate(context),
    );
  }

  /// Opens a date picker dialog to select a date.
  ///
  /// This function presents a date picker to the user, allowing them to select
  /// a date. The selected date is then stored in the [_selectedDate] variable
  /// if it differs from the current value.
  Future<void> _selectDate(BuildContext context) async {
    // Show the date picker and wait for the user's selection.
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    // If a date is picked and it is different from the current selection, update the state.
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  /// Adds a task to the database.
  ///
  /// This function is called when the user clicks the "Add task" button.
  /// It takes the text from the name and description text fields, and the
  /// selected priority, status, and deadline from the dropdown menus and
  /// date picker, and adds a task to the database with the specified
  /// details.
  ///
  /// The task is then added to the state of the [TaskBloc].
  ///
  /// After adding the task, the function navigates back to the previous
  /// screen.

  void _addTask(BuildContext context) {
    final taskName = _nameController.text;
    final taskDescription = _descriptionController.text;
    final taskPriority = _selectedPriority ?? 'Không ưu tiên';
    final taskStatus = _selectedStatus ?? 'Chưa hoàn thành';
    final taskDeadline = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : '';
    context.read<TaskBloc>().add(
          AddTaskEvent(
            name: taskName,
            description: taskDescription,
            priority: taskPriority,
            status: taskStatus,
            deadline: taskDeadline,
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thêm công việc thành công!'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }
}
