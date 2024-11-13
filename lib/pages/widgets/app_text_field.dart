part of 'app_widget.dart';

// TextField(
// controller: _nameController,
// decoration: InputDecoration(
// hintText: 'Tên Nhiệm Vụ',
// hintStyle: const TextStyle(color: Color(0xFF818181)),
// border: OutlineInputBorder(
// borderSide: BorderSide.none,
// borderRadius: BorderRadius.circular(8.0),
// ),
// filled: true,
// fillColor: const Color(0xFF353535)),
// style: const TextStyle(color: Colors.white),
// ),

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.maxLines,
  });

  final String hintText;
  final TextEditingController? controller;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF818181)),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: const Color(0xFF353535),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
