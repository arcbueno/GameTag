import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final DropdownButton button;
  const CustomDropdown({super.key, required this.button, required this.label});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: button,
      ),
    );
  }
}
