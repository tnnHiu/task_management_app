// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
part of 'app_widget.dart';

class CustomDateTimePicker extends StatelessWidget {
  final DateTime? selectedDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;
  final String label;

  CustomDateTimePicker({
    required this.selectedDateTime,
    required this.onDateTimeChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        ElevatedButton(
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDateTime ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
              );

              if (pickedTime != null) {
                final dateTime = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );
                onDateTimeChanged(dateTime); 
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 196, 131, 9),
            foregroundColor: Colors.white,
            shadowColor: Colors.black,
            elevation: 5,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            selectedDateTime == null
                ? 'Chọn Thời Gian'
                : DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime!),
          ),
        ),
      ],
    );
  }
}
