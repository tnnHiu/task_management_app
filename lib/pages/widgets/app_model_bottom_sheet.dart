// part of 'app_widget.dart';

// Tạm thời chưa tách

//
//   void _showTaskDetails(BuildContext context) {
//     TextEditingController textController =
//         TextEditingController(text: widget.text);
//     TextEditingController descriptionController =
//         TextEditingController(text: widget.description);
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.45,
//           decoration: BoxDecoration(
//             color: Colors.grey[850],
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () {
//                         BlocProvider.of<TaskBloc>(context).add(
//                           UpdateTaskEvent(
//                             updatedTask: TaskModel(
//                               id: widget.taskId,
//                               name: textController.text,
//                               description: descriptionController.text,
//                               priority: widget.priority,
//                               status: widget.isCompleted
//                                   ? 'Đã hoàn thành'
//                                   : 'Chưa hoàn thành',
//                               deadline: widget.date ?? Timestamp.now(),
//                               userId: _auth.currentUser!.uid,
//                             ),
//                           ),
//                         );
//                         Navigator.pop(context);
//                       },
//                     ),
//                     const Text(
//                       'Chi Tiết Công Việc',
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                     const Icon(Icons.more_vert, color: Colors.white),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: widget.isCompleted,
//                       onChanged: (bool? value) {
//                         BlocProvider.of<TaskBloc>(context).add(
//                           ToggleTaskCompletionEvent(
//                             taskId: widget.taskId,
//                             isCompleted: !value!,
//                           ),
//                         );
//                         Navigator.pop(context);
//                       },
//                       activeColor: Colors.orange,
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: GestureDetector(
//                           onTap: () async {
//                             DateTime? selectedDate = await showDatePicker(
//                               context: context,
//                               initialDate:
//                                   widget.date?.toDate() ?? DateTime.now(),
//                               firstDate: DateTime(2000),
//                               lastDate: DateTime(2100),
//                               builder: (BuildContext context, Widget? child) {
//                                 return Theme(
//                                   data: ThemeData.dark().copyWith(
//                                     colorScheme: ColorScheme.dark(
//                                       primary: Colors.orange,
//                                       onPrimary: Colors.white,
//                                       surface: Color.fromARGB(255, 68, 65, 65),
//                                       onSurface: Colors.white,
//                                     ),
//                                     dialogBackgroundColor: Colors.grey[900],
//                                   ),
//                                   child: child!,
//                                 );
//                               },
//                             );
//
//                             if (selectedDate != null) {
//                               BlocProvider.of<TaskBloc>(context).add(
//                                 UpdateTaskEvent(
//                                   updatedTask: TaskModel(
//                                     id: widget.taskId,
//                                     name: textController.text,
//                                     description: descriptionController.text,
//                                     priority: widget.priority,
//                                     status: widget.isCompleted
//                                         ? 'Đã hoàn thành'
//                                         : 'Chưa hoàn thành',
//                                     deadline: Timestamp.fromDate(selectedDate),
//                                     userId: _auth.currentUser!.uid,
//                                   ),
//                                 ),
//                               );
//                             }
//                           },
//                           child: Text(
//                             DateFormat('dd/MM/yyyy').format(
//                                 widget.date?.toDate() ?? DateTime.now()),
//                             style: const TextStyle(color: Colors.white70),
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         // Hiển thị menu chọn mức độ ưu tiên
//                         showModalBottomSheet(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[850],
//                                 borderRadius: const BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   topRight: Radius.circular(20),
//                                 ),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text('Chọn Mức Độ Ưu Tiên',
//                                       style: TextStyle(
//                                           color: Colors.white, fontSize: 16)),
//                                   ListTile(
//                                     leading: const Icon(Icons.flag,
//                                         color: Colors.red),
//                                     title: const Text('Cao',
//                                         style: TextStyle(color: Colors.white)),
//                                     onTap: () {
//                                       setState(() {
//                                         widget.priority = 'Cao';
//                                         widget.flagColor = Colors.red;
//                                       });
//                                       Navigator.pop(context);
//                                     },
//                                   ),
//                                   ListTile(
//                                     leading: const Icon(Icons.flag,
//                                         color: Colors.yellow),
//                                     title: const Text('Vừa',
//                                         style: TextStyle(color: Colors.white)),
//                                     onTap: () {
//                                       setState(() {
//                                         widget.priority = 'Vừa';
//                                         widget.flagColor = Colors.yellow;
//                                       });
//                                       Navigator.pop(context);
//                                     },
//                                   ),
//                                   ListTile(
//                                     leading: const Icon(Icons.flag,
//                                         color: Colors.blue),
//                                     title: const Text('Thấp',
//                                         style: TextStyle(color: Colors.white)),
//                                     onTap: () {
//                                       setState(() {
//                                         widget.priority = 'Thấp';
//                                         widget.flagColor = Colors.blue;
//                                       });
//                                       Navigator.pop(context);
//                                     },
//                                   ),
//                                   ListTile(
//                                     leading: const Icon(Icons.flag,
//                                         color: Colors.white),
//                                     title: const Text('Không Ưu Tiên',
//                                         style: TextStyle(color: Colors.white)),
//                                     onTap: () {
//                                       setState(() {
//                                         widget.priority = 'Không ưu tiên';
//                                         widget.flagColor = Colors.white;
//                                       });
//                                       Navigator.pop(context);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       },
//                       child: Icon(Icons.flag,
//                           color: widget
//                               .flagColor), // Hiển thị cờ với màu tương ứng
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: textController,
//                   decoration: const InputDecoration(
//                     hintText: 'Tên công việc',
//                     hintStyle: TextStyle(color: Colors.white70),
//                     border: InputBorder.none,
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: descriptionController,
//                   decoration: const InputDecoration(
//                     hintText: 'Mô tả',
//                     hintStyle: TextStyle(color: Colors.white70),
//                     border: InputBorder.none,
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
