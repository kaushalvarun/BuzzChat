class BcUser {
  String _username;
  String _email;
  String _status;
  List<Map<String, dynamic>> _groups;

  BcUser({
    required String username,
    required String email,
    required String status,
    required List<Map<String, dynamic>> groups,
  })  : _username = username,
        _email = email,
        _status = status,
        _groups = groups;

  Map<String, dynamic> toMap() {
    return {
      'username': _username,
      'email': _email,
      'status': _status,
      'groups': _groups,
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

  List<Map<String, dynamic>> getGroups() {
    return _groups;
  }

  void setGroups(List<Map<String, dynamic>> groups) {
    _groups = groups;
  }

  @override
  String toString() {
    return 'BcUser{username: $_username, email: $_email, status: $_status}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BcUser &&
        other._username == _username &&
        other._email == _email &&
        other._status == _status;
  }

  @override
  int get hashCode => _username.hashCode ^ _email.hashCode ^ _status.hashCode;
}
