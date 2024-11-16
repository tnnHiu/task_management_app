import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/events/event_bloc_event.dart';
import '../../blocs/events/event_bloc.dart';
import '../../blocs/events/event_bloc_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

//widget
import '../../pages/widgets/app_widget.dart';
class EditEventPage extends StatefulWidget {
  final event;
  EditEventPage({required this.event});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
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

  @override
  void initState() {
    super.initState();
      _titleController.text = widget.event.title ?? '';
      _locationController.text = widget.event.location ?? '';
      _descriptionController.text = widget.event.description ?? '';
      _startDateTime = widget.event.startTime;
      _endDateTime = widget.event.endTime;
      _smartReminder = widget.event.smartReminder ?? 'Không có';
      _selectedRepeatOption = widget.event.repeatOption ?? 'Không lặp lại';
      _repeatEndDate = widget.event.repeatEndDate;

      if (_selectedRepeatOption != 'Không lặp lại') {
        _showRepeatEndOptions = true;
        _selectedRepeatEndOption = widget.event.repeatEndOption ?? 'Ngày';
      }
      if (_selectedRepeatEndOption == 'Ngày') {
        _repeatEndDate = widget.event.repeatEndDate;
      }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242424), 
      appBar: AppBar(
        backgroundColor: Color(0xFF242424),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Chỉnh Sửa Sự Kiện',
                textAlign: TextAlign.center, 
                style: TextStyle(color: Colors.white),
              ),
            ),
            
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () {
                final eventBloc = BlocProvider.of<EventBloc>(context);
                eventBloc.add(DeleteEvent(
                  eventId: widget.event.id,
                  userId: userId,  
                ));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sự kiện đã được xóa!')),
                );
                Navigator.of(context).pop(); 
              },
            ),
          ],
        ),
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
                  ),
                  child: DropdownButton<String>(
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
              onPressed: () async {
                final eventBloc = BlocProvider.of<EventBloc>(context);

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

                eventBloc.add(UpdateEvent(
                  eventId: widget.event.id,
                  eventDetails: eventDetails,
                  userId: userId,
                ));

                await Future.delayed(Duration(seconds: 1));
                final state = eventBloc.state;

                if (state is EventUpdatedSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật sự kiện thành công!')));
                  Navigator.of(context).pop();  
                } else if (state is EventUpdatedFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 196, 131, 9),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                
              ),
              child: Text('Lưu', style: TextStyle(fontSize: 16, color: Colors.white), ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRepeatOptionChanged(String? newOption) {
    setState(() {
      _selectedRepeatOption = newOption;
      _showRepeatEndOptions = newOption != 'Không lặp lại';
      _repeatEndDate = null; 
    });
  }

  void _onRepeatEndOptionChanged(String? newEndOption) {
    setState(() {
      _selectedRepeatEndOption = newEndOption;
    });
  }
}
