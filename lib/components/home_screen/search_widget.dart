import 'package:flutter/material.dart';

class MySearchWidget extends StatelessWidget {
  final TextEditingController controller;
  const MySearchWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1),
      child: TextField(
        controller: controller,
        enableSuggestions: false,
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
        decoration: InputDecoration(
          fillColor: Colors.grey[100],
          filled: true,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey[700]),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
