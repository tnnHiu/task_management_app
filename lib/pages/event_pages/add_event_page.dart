import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/events/event_bloc.dart';
import '../../blocs/events/event_bloc_event.dart';
import 'package:firebase_auth/firebase_auth.dart';

//widget
import '../../pages/widgets/app_widget.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  DateTime? _startDateTime;
  DateTime? _endDateTime;
  String? _smartReminder = 'Không có';
  DateTime? _repeatEndDate;
  bool _showRepeatEndOptions = false;
  String? _selectedRepeatEndOption;
  String? _selectedRepeatOption;
  


  List<String> _reminderOptions = [
    'Không có',
    'Sớm 5p',
    'Sớm 30p',
    'Sớm 1 giờ',
    'Sớm 1 ngày',
    'Nhắc nhở liên tục'
  ];


  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Color.fromARGB(255, 68, 65, 65),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          final dateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStart) {
            _startDateTime = dateTime;
          } else {
            _endDateTime = dateTime;
          }
        });
      }
    }
  }

  void _onRepeatOptionChanged(String? value) {
    setState(() {
      _selectedRepeatOption = value;
      _showRepeatEndOptions = value != 'Không lặp lại';
      _selectedRepeatEndOption = null;
      _repeatEndDate = null;
    });
  }

  void _onRepeatEndOptionChanged(String? value) {
    setState(() {
      _selectedRepeatEndOption = value;
      if (value == 'Ngày') {
        _repeatEndDate = null;
      }
    });
  }

  void _addEvent() {
  if (_titleController.text.isNotEmpty &&
      _locationController.text.isNotEmpty &&
      _descriptionController.text.isNotEmpty &&
      _startDateTime != null &&
      _endDateTime != null) {
    
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

    BlocProvider.of<EventBloc>(context).add(AddEvent(
      eventDetails: eventDetails,
      userId: userId,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sự kiện đã được thêm thành công')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242424),
      appBar: AppBar(
        title: Text('Thêm Sự Kiện', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF353535),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            CustomTextField(controller: _titleController, hintText: 'Tiêu Đề'),
            SizedBox(height: 16.0),
            CustomTextField(controller: _locationController, hintText: 'Địa điểm'),
            SizedBox(height: 16.0),
            CustomTextField(controller: _descriptionController, hintText: 'Mô tả'),
            SizedBox(height: 16.0),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nhắc Nhở Thông Minh', style: TextStyle(color: Colors.white)),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 196, 131, 9),
                  ), child: DropdownButton<String>(
                      value: _smartReminder,
                      dropdownColor: Color(0xFF353535),
                      underline: SizedBox(),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      style: TextStyle(color: Colors.white),
                      onChanged: (String? newValue) {
                        setState(() {
                          _smartReminder = newValue!;
                        });
                      },
                      items: _reminderOptions.map<DropdownMenuItem<String>>((String value) {
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
            ElevatedButton(
                onPressed: _addEvent,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 196, 131, 9), 
                  foregroundColor: Colors.white, 
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
