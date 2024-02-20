import 'package:cloud_firestore/cloud_firestore.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  if (dateTime.hour > 12) {
    return '${dateTime.hour - 12}:${_twoDigits(dateTime.minute)} PM';
  } else if (dateTime.hour == 0) {
    return '${dateTime.hour + 12}:${_twoDigits(dateTime.minute)} AM';
  } else {
    return '${dateTime.hour}:${_twoDigits(dateTime.minute)} AM';
  }
}

String _twoDigits(int n) {
  if (n >= 10) {
    return '$n';
  }
  return '0$n';
}
