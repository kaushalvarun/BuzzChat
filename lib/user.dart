import 'package:flutter/foundation.dart';

class BcUser {
  String _username;
  String _email;
  String _status;
  List<dynamic> _groups;
  List<dynamic> _recentChats;

  BcUser({
    required String username,
    required String email,
    required String status,
    required List<dynamic> groups,
    required List<dynamic> recentChats,
  })  : _username = username,
        _email = email,
        _status = status,
        _groups = groups,
        _recentChats = recentChats;

  Map<String, dynamic> toMap() {
    return {
      'username': _username,
      'email': _email,
      'status': _status,
      'groups': _groups.map((group) => group.toMap()).toList(),
      'recentChats': _recentChats.map((user) => user.toMap()).toList(),
    };
  }

  String getUsername() {
    return _username;
  }

  void setUsername(String username) {
    _username = username;
  }

  String getEmail() {
    return _email;
  }

  void setEmail(String email) {
    _email = email;
  }

  String getStatus() {
    return _status;
  }

  void setStatus(String status) {
    _status = status;
  }

  List<dynamic> getGroups() {
    return _groups;
  }

  void setGroups(List<dynamic> groups) {
    _groups = groups;
  }

  @override
  String toString() {
    return 'BcUser{username: $_username, email: $_email, status: $_status}';
  }

  List<dynamic> getRecentChats() {
    return _recentChats;
  }

  void setRecentChats(List<dynamic> recentChats) {
    _recentChats = recentChats;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BcUser &&
        other._username == _username &&
        other._email == _email &&
        other._status == _status &&
        listEquals(other._groups, _groups) &&
        listEquals(other._recentChats, _recentChats);
  }

  @override
  int get hashCode =>
      _username.hashCode ^
      _email.hashCode ^
      _status.hashCode ^
      _groups.hashCode ^
      _recentChats.hashCode;
}
