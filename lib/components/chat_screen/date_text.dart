import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateText extends StatelessWidget {
  final DateTime date;
  const DateText({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        dateText(date),
      ),
    );
  }
}

// helper functions
const String dateFormatter = 'MMMM dd, y';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    // here yere is this.year, etc
    return year == other.year && month == other.month && day == other.day;
  }
}

// check if date is today, yesterday or other date
String dateText(DateTime date) {
  // date istoday
  if (date.isSameDate(DateTime.now())) {
    return 'Today';
  }
  // date is yesterday
  else if (date.isSameDate(DateTime.now().subtract(const Duration(days: 1)))) {
    return 'Yesterday';
  }
  // other date
  else {
    return date.formatDate();
  }
}
