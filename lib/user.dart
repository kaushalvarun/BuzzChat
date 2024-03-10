// ignore_for_file: prefer_initializing_formals
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class BcUser {
  String username;
  String email;
  String status;
  List<String> groups;

  BcUser({
    required String username,
    required String email,
    required String status,
    required List<String> groups,
  })  : username = username,
        email = email,
        status = status,
        groups = groups;

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'status': status,
      'groups': groups,
    };
  }

  // Fetch data from db format
  factory BcUser.fromJson(Map<String, dynamic> json) => _$BcUserFromJson(json);

  // Write data to db format
  Map<String, dynamic> toJson() => _$BcUserToJson(this);

  String getUsername() {
    return username;
  }

  void setUsername(String username) {
    username = username;
  }

  String getEmail() {
    return email;
  }

  void setEmail(String email) {
    email = email;
  }

  String getStatus() {
    return status;
  }

  void setStatus(String status) {
    status = status;
  }

  List<String> getGroups() {
    return groups;
  }

  void setGroups(List<Map<String, dynamic>> groups) {
    groups = groups;
  }

  @override
  String toString() {
    return 'BcUser{username: $username, email: $email, status: $status}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BcUser &&
        other.username == username &&
        other.email == email &&
        other.status == status;
  }

  @override
  int get hashCode => username.hashCode ^ email.hashCode ^ status.hashCode;
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<BcUser?> userfromEmail(String email) async {
  try {
    var userDocs = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userDocs.docs.isNotEmpty) {
      Map<String, dynamic> userMap = userDocs.docs[0].data();
      return BcUser.fromJson(userMap);
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error getting user from email \n=>Error: $e');
  }
  return null; // user is not found or an error occurs
}
