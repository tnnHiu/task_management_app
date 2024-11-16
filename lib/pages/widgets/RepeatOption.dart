// import 'package:flutter/material.dart';
part of 'app_widget.dart';

class RepeatOptions extends StatelessWidget {
  final String? selectedRepeatOption;
  final Function(String?) onRepeatOptionChanged;
  final bool showRepeatEndOptions;
  final String? selectedRepeatEndOption;
  final Function(String?) onRepeatEndOptionChanged;
  final DateTime? selectedEndDate;
  final Function(DateTime?) onEndDateChanged;

  RepeatOptions({
    Key? key,
    required this.selectedRepeatOption,
    required this.onRepeatOptionChanged,
    required this.showRepeatEndOptions,
    required this.selectedRepeatEndOption,
    required this.onRepeatEndOptionChanged,
    required this.selectedEndDate,
    required this.onEndDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> repeatOptions = [
      'Không lặp lại',
      'Mỗi ngày',
      'Mỗi tuần',
      'Mỗi tháng',
      'Mỗi năm',
    ];

    final List<String> repeatEndOptions = [
      'Không',
      'Ngày',
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tùy Chọn Lặp Lại', style: TextStyle(color: Colors.white)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 196, 131, 9),
              ),
              child: DropdownButton<String>(
                value: selectedRepeatOption,
                dropdownColor: Color(0xFF353535),
                underline: SizedBox(),
                padding: EdgeInsets.symmetric(horizontal: 15),
                style: TextStyle(color: Colors.white),
                hint: Text('Chọn Lặp Lại', style: TextStyle(color: Colors.white)),
                onChanged: onRepeatOptionChanged,
                items: repeatOptions.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        if (showRepeatEndOptions)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ngày Kết Thúc', style: TextStyle(color: Colors.white)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 196, 131, 9),
                ),
                child: DropdownButton<String>(
                  value: selectedRepeatEndOption,
                  dropdownColor: Color(0xFF353535),
                  underline: SizedBox(),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  style: TextStyle(color: Colors.white),
                  hint: Text('Chọn Ngày Kết Thúc', style: TextStyle(color: Colors.white)),
                  onChanged: onRepeatEndOptionChanged,
                  items: repeatEndOptions.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        if (selectedRepeatEndOption == 'Ngày' && showRepeatEndOptions)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chọn Ngày Kết Thúc', style: TextStyle(color: Colors.white)),
                GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedEndDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedEndDate) {
                      onEndDateChanged(pickedDate);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 196, 131, 9),
                    ),
                    child: Text(
                      selectedEndDate != null
                          ? '${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}'
                          : 'Chọn Ngày',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
