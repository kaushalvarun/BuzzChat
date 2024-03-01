import 'package:buzzchatv2/user.dart';

class Group {
  String _groupName;
  List<BcUser> _members;
  // String _description;
  String _creatorOfGroup;
  // List<BcUser> _admins;
  String _groupChatRoomId;

  Group({
    required String groupName,
    required List<BcUser> members,
    // required String description,
    required String creatorOfGroup,
    // required List<BcUser> admins,
    required String groupChatRoomId,
  })  : _groupName = groupName,
        _members = members,
        // _description = description,
        _creatorOfGroup = creatorOfGroup,
        // _admins = admins,
        _groupChatRoomId = groupChatRoomId;

  Map<String, dynamic> toMap() {
    return {
      'groupName': _groupName,
      // 'description': _description,
      'groupChatRoomId': _groupChatRoomId,
      'members': _members.map((user) => user.toMap()).toList(),
      'creatorOfGroup': _creatorOfGroup,
      // 'admins': _admins.map((user) => user.toMap()).toList(),
    };
  }

  String getGroupName() {
    return _groupName;
  }

  void setGroupName(String name) {
    _groupName = name;
  }

  List<BcUser> getMembers() {
    return _members;
  }

  void setMembers(List<BcUser> members) {
    _members = members;
  }

  // String getDescription() {
  //   return _description;
  // }

  // void setDescription(String description) {
  //   _description = description;
  // }

  String getCreatorOfGroup() {
    return _creatorOfGroup;
  }

  void setCreatorOfGroup(String creator) {
    _creatorOfGroup = creator;
  }

  // List<BcUser> getAdmins() {
  //   return _admins;
  // }

  // void setAdmins(List<BcUser> admins) {
  //   _admins = admins;
  // }

  String getGroupChatRoomId() {
    return _groupChatRoomId;
  }

  void setGroupChatRoomId(String id) {
    _groupChatRoomId = id;
  }
}

List<Group> getListOfGroupFromListOfMap(
    List<Map<String, dynamic>> groupsInMap) {
  List<Group> groups = [];
  for (Map<String, dynamic> groupMap in groupsInMap) {
    List<BcUser> members = [];
    for (Map<String, dynamic> memberMap in groupMap['members']) {
      members.add(BcUser(
        username: memberMap['username'],
        email: memberMap['email'],
        status: memberMap['status'],
        groups: List<Map<String, dynamic>>.from(memberMap['groups']),
      ));
    }
    groups.add(
      Group(
        groupName: groupMap['groupName'],
        members: members,
        creatorOfGroup: groupMap['creatorOfGroup'],
        groupChatRoomId: groupMap['groupChatRoomId'],
      ),
    );
  }
  return groups;
}
