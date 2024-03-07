import 'package:flutter/material.dart';

class PhotoContainer extends StatelessWidget {
  final double width;
  const PhotoContainer({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: width,
        child: Image.asset(
          'lib/images/groupDefault.png',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
