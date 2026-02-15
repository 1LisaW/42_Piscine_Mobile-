import 'package:flutter/material.dart';

class LocationSearchField extends StatelessWidget {
  final String query;
  final TextEditingController textController;
  final Function(String) onSubmitted;

  const LocationSearchField({
    super.key,
    required this.query,
    required this.textController,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 1.5, color: Colors.white)),
      ),
      child: TextField(
        controller: textController,
        style: TextStyle(
          color: Colors.grey.shade300,
          decoration: TextDecoration.none,
          decorationThickness: 0,
        ),
        decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
          fillColor: Colors.grey.shade300,
          hintText: 'Search location...',
          hintStyle: TextStyle(color: Colors.grey.shade300),
          prefixIcon: const Icon(
            Icons.search,
            color: Color.fromARGB(255, 228, 224, 224),
          ),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
