part of 'app_widget.dart';

// item của task, bao gồm cả click hiển thị bottom sheet,
// tạm thời chưa tách ra file riêng và chưa sử dụng bloc

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.taskId,
    required this.text,
    required this.isCompleted,
    required this.date,
    required this.description,
    required this.priority,
    required this.flagColor,
  });

  final String taskId;
  final String text;
  final bool isCompleted;
  final Timestamp? date;
  final String description;
  final String priority;
  final Color flagColor;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late String priority;
  late Color flagColor;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showTaskDetails(BuildContext context) {
    // Tạo bộ điều khiển cho các trường văn bản
    TextEditingController textController =
        TextEditingController(text: widget.text);
    TextEditingController descriptionController =
        TextEditingController(text: widget.description);

    // Hiển thị BottomSheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return BlocProvider.value(
          value: BlocProvider.of<TaskBloc>(context),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thanh tiêu đề với nút quay lại và tiêu đề
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          BlocProvider.of<TaskBloc>(context).add(
                            UpdateTaskEvent(
                              updatedTask: TaskModel(
                                id: widget.taskId,
                                name: textController.text,
                                description: descriptionController.text,
                                priority: widget.priority,
                                status: widget.isCompleted
                                    ? 'Đã hoàn thành'
                                    : 'Chưa hoàn thành',
                                deadline: widget.date ?? Timestamp.now(),
                                userId: _auth.currentUser!.uid,
                              ),
                            ),
                          );
                          Navigator.pop(modalContext);
                        },
                      ),
                      const Text(
                        'Chi Tiết Công Việc',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const Icon(Icons.more_vert, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Hàng chứa Checkbox và ngày
                  Row(
                    children: [
                      Checkbox(
                        value: widget.isCompleted,
                        onChanged: (bool? value) {
                          BlocProvider.of<TaskBloc>(context).add(
                            ToggleTaskCompletionEvent(
                              taskId: widget.taskId,
                              isCompleted: value ?? false,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        activeColor: Colors.orange,
                      ),
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    widget.date?.toDate() ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Colors.orange,
                                        onPrimary: Colors.white,
                                        surface: Colors.grey[850]!,
                                        onSurface: Colors.white,
                                      ),
                                      dialogBackgroundColor: Colors.grey[900],
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (selectedDate != null) {
                                BlocProvider.of<TaskBloc>(context).add(
                                  UpdateTaskEvent(
                                    updatedTask: TaskModel(
                                      id: widget.taskId,
                                      name: textController.text,
                                      description: descriptionController.text,
                                      priority: widget.priority,
                                      status: widget.isCompleted
                                          ? 'Đã hoàn thành'
                                          : 'Chưa hoàn thành',
                                      deadline:
                                          Timestamp.fromDate(selectedDate),
                                      userId: _auth.currentUser!.uid,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(
                                  widget.date?.toDate() ?? DateTime.now()),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Chọn Mức Độ Ưu Tiên',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    _buildTaskPriorityOption(
                                        context, "Cao", Colors.red),
                                    _buildTaskPriorityOption(
                                        context, "Vừa", Colors.yellow),
                                    _buildTaskPriorityOption(
                                        context, "Thấp", Colors.blue),
                                    _buildTaskPriorityOption(
                                        context, "Không ưu tiên", Colors.white),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(Icons.flag, color: widget.flagColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Trường nhập tên công việc
                  TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'Tên công việc',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // Trường nhập mô tả công việc
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Mô tả',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    priority = widget.priority;
    flagColor = widget.flagColor;
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = widget.date != null
        ? DateFormat('dd/MM/yyyy').format(widget.date!.toDate())
        : '';

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return Slidable(
          key: ValueKey(widget.taskId),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              // gọi slide action
              _buildSlideAction(
                context: context,
                icon: Icons.delete,
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                text: 'Xóa',
                onPressed: () {
                  BlocProvider.of<TaskBloc>(context)
                      .add(DeleteTaskEvent(taskId: widget.taskId));
                },
              ),
              _buildSlideAction(
                context: context,
                icon: Icons.calendar_today,
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                text: 'Nhắc nhở',
                onPressed: () {
                  //TODO
                },
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () =>
                _showTaskDetails(context), // Sử dụng khi cần show chi tiết task
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  _buildCheckbox(context),
                  _buildTaskInfo(formattedDate),
                  _buildSetPriorityPopup(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // pop up hiển thị mức độ ưu tiên của công việc ở task item
  // (Tận dụng để thêm vào trong bottom sheet -> để sau )
  GestureDetector _buildSetPriorityPopup(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (_) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: _buildTaskPriorityList(context),
        ),
      ),
      child: Icon(Icons.flag, color: flagColor),
    );
  }

  // Hiển thị danh sách độ ưu tiên trong pop up
  Column _buildTaskPriorityList(BuildContext context) {
    return Column(
      children: [
        _buildTaskPriorityOption(context, "Cao", Colors.red),
        _buildTaskPriorityOption(context, "Vừa", Colors.yellow),
        _buildTaskPriorityOption(context, "Thấp", Colors.blue),
        _buildTaskPriorityOption(context, "Không ưu tiên", Colors.white),
      ],
    );
  }

  // Hiển thị từng item độ ưu tiên trong danh sách độ ưu tiên
  ListTile _buildTaskPriorityOption(
      BuildContext context, String text, Color iconColor) {
    return ListTile(
      title: Text(text, style: const TextStyle(color: Colors.white)),
      leading: Icon(Icons.flag, color: iconColor),
      onTap: () {
        setState(() {
          priority = text;
          flagColor = iconColor;
        });

        BlocProvider.of<TaskBloc>(context).add(
          UpdateTaskEvent(
            updatedTask: TaskModel(
              id: widget.taskId,
              name: widget.text,
              description: widget.description,
              priority: priority,
              status: widget.isCompleted ? 'Đã hoàn thành' : 'Chưa hoàn thành',
              deadline: widget.date!,
              userId: _auth.currentUser!.uid,
            ),
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  // Hiển thị phần thông tin công việc
  Expanded _buildTaskInfo(String formattedDate) {
    final isOverdue = widget.date != null && widget.date!.toDate().isBefore(DateTime.now());
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: TextStyle(
              color: widget.isCompleted ? Colors.white54 : Colors.white,
              fontSize: 16.0,
              decoration:
                  widget.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          if (formattedDate.isNotEmpty)
            Text(
              formattedDate,
              style: TextStyle(
                color: isOverdue ? Colors.red : Colors.white54,
                fontSize: 14.0,
              ),
            ),
        ],
      ),
    );
  }

  // check box để đánh dấu công việc đã hoàn thành hay chưa
  // (tận dụng để thêm vào bottom sheet)
  Checkbox _buildCheckbox(BuildContext context) {
    return Checkbox(
      value: widget.isCompleted,
      onChanged: (value) {
        BlocProvider.of<TaskBloc>(context).add(
          ToggleTaskCompletionEvent(
            taskId: widget.taskId,
            isCompleted: value ?? false,
          ),
        );
      },
      activeColor: Colors.orange,
    );
  }

  // Hành động khi vuốt task item sang trái
  SlidableAction _buildSlideAction({
    required BuildContext context,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
    required String text,
    required void Function() onPressed,
  }) {
    return SlidableAction(
      onPressed: (context) {
        _showConfirmationDialog(context, onPressed);
      },
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      icon: icon,
      label: text,
    );
  }

  void _showConfirmationDialog(BuildContext context, void Function() onConfirmed) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc muốn xóa không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
                onConfirmed();
              },
              child: const Text('Có'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
              },
              child: const Text('Không'),
            ),
            
          ],
        );
      },
    );
  }
}
