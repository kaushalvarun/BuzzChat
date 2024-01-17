import 'package:uuid/uuid.dart';

String chatroomId(String user1, String user2) {
  // Sort usernames to retain consistency
  final List<String> sortedList = [user1, user2];
  sortedList.sort();

  // Combine them with hyphen
  final String combinedIds = sortedList.join('-');

  // Generate random id based on this using UUID
  final uuid = const Uuid().v5(Uuid.NAMESPACE_URL, combinedIds);

  return uuid;
}
