import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final Function()? onTap;
  final String imagePath;
  const SquareTile({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 127, 168, 123)),
            color: const Color.fromARGB(255, 228, 235, 202),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            imagePath,
            height: 40,
          )),
    );
  }
}
