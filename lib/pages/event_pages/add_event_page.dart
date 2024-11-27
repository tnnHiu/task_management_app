import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/events/event_bloc.dart';
import '../../blocs/events/event_bloc_event.dart';
// Widget tùy chỉnh
import '../../pages/widgets/app_widget.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  // Các bộ điều khiển TextField để nhập liệu
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Lấy userId từ Firebase Auth để liên kết sự kiện với người dùng
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Các biến lưu thời gian, lặp lại và nhắc nhở
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  String? _smartReminder = 'Không có';
  DateTime? _repeatEndDate;
  bool _showRepeatEndOptions = false;
  String? _selectedRepeatEndOption;
  String? _selectedRepeatOption;

  // Các tùy chọn nhắc nhở thông minh
  final List<String> _reminderOptions = [
    'Không có',
    'Sớm 5p',
    'Sớm 30p',
    'Sớm 1 giờ',
    'Sớm 1 ngày',
    'Nhắc nhở liên tục'
  ];

  // Xử lý khi tùy chọn lặp lại thay đổi
  void _onRepeatOptionChanged(String? value) {
    setState(() {
      _selectedRepeatOption = value;
      _showRepeatEndOptions = value != 'Không lặp lại';
      _selectedRepeatEndOption = null;
      _repeatEndDate = null;
    });
  }

  // Xử lý khi tùy chọn kết thúc lặp lại thay đổi
  void _onRepeatEndOptionChanged(String? value) {
    setState(() {
      _selectedRepeatEndOption = value;
      if (value == 'Ngày') {
        _repeatEndDate = null; // Đặt lại ngày nếu chọn "Ngày"
      }
    });
  }

  // Hàm thêm sự kiện
  void _addEvent() {
    // Kiểm tra xem tất cả thông tin đã được điền hay chưa
    if (_titleController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _startDateTime != null &&
        _endDateTime != null) {
      // Tạo đối tượng EventDetails để lưu trữ thông tin sự kiện
      final eventDetails = EventDetails(
        userId: userId,
        title: _titleController.text,
        location: _locationController.text,
        description: _descriptionController.text,
        startTime: _startDateTime!,
        endTime: _endDateTime!,
        smartReminder: _smartReminder,
        repeatOption: _selectedRepeatOption,
        repeatEndDate: _repeatEndDate,
        repeatEndOption: _selectedRepeatEndOption,
      );

      // Gửi sự kiện AddEvent tới EventBloc
      BlocProvider.of<EventBloc>(context).add(AddEvent(
        eventDetails: eventDetails,
        userId: userId,
      ));

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sự kiện đã được thêm thành công')),
      );
    } else {
      // Hiển thị thông báo lỗi nếu thông tin chưa đầy đủ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242424), // Màu nền chính
      appBar: AppBar(
        title: Text('Thêm Sự Kiện', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF353535), // Màu nền AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0), // Khoảng cách xung quanh
        child: Column(
          children: [
            // TextField nhập tiêu đề
            CustomTextField(controller: _titleController, hintText: 'Tiêu Đề'),
            SizedBox(height: 16.0),
            // TextField nhập địa điểm
            CustomTextField(
                controller: _locationController, hintText: 'Địa điểm'),
            SizedBox(height: 16.0),
            // TextField nhập mô tả
            CustomTextField(
                controller: _descriptionController, hintText: 'Mô tả'),
            SizedBox(height: 16.0),
            // Bộ chọn thời gian bắt đầu
            CustomDateTimePicker(
              selectedDateTime: _startDateTime,
              onDateTimeChanged: (newDateTime) {
                setState(() {
                  _startDateTime = newDateTime;
                });
              },
              label: 'Thời Gian Bắt Đầu',
            ),
            SizedBox(height: 16.0),
            // Bộ chọn thời gian kết thúc
            CustomDateTimePicker(
              selectedDateTime: _endDateTime,
              onDateTimeChanged: (newDateTime) {
                setState(() {
                  _endDateTime = newDateTime;
                });
              },
              label: 'Thời Gian Kết Thúc',
            ),
            SizedBox(height: 16.0),
            // Tùy chọn lặp lại sự kiện
            RepeatOptions(
              selectedRepeatOption: _selectedRepeatOption,
              onRepeatOptionChanged: _onRepeatOptionChanged,
              showRepeatEndOptions: _showRepeatEndOptions,
              selectedRepeatEndOption: _selectedRepeatEndOption,
              onRepeatEndOptionChanged: _onRepeatEndOptionChanged,
              selectedEndDate: _repeatEndDate,
              onEndDateChanged: (newEndDate) {
                setState(() {
                  _repeatEndDate = newEndDate;
                });
              },
            ),
            SizedBox(height: 16.0),
            // Dropdown chọn nhắc nhở thông minh
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nhắc Nhở Thông Minh',
                    style: TextStyle(color: Colors.white)),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 196, 131, 9), // Màu nền dropdown
                  ),
                  child: DropdownButton<String>(
                    value: _smartReminder,
                    dropdownColor: Color(0xFF353535), // Màu nền menu dropdown
                    underline: SizedBox(), // Bỏ gạch chân
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    style: TextStyle(color: Colors.white),
                    onChanged: (String? newValue) {
                      setState(() {
                        _smartReminder = newValue!;
                      });
                    },
                    items: _reminderOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            // Nút Lưu Sự Kiện
            ElevatedButton(
              onPressed: _addEvent, // Gọi hàm thêm sự kiện
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 196, 131, 9), // Màu nền
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bo góc
                ),
              ),
              child: Text('Lưu Sự Kiện'),
            ),
          ],
        ),
      ),
    );
  }
}
