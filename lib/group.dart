import 'package:buzzchatv2/user.dart';

class Group {
  String _groupName;
  List<BcUser> _members;
  String _description;
  BcUser _creatorOfGroup;
  List<BcUser> _admins;
  String _groupChatRoomId;

  Group({
    required String groupName,
    required List<BcUser> members,
    required String description,
    required BcUser creatorOfGroup,
    required List<BcUser> admins,
    required String groupChatRoomId,
  })  : _groupName = groupName,
        _members = members,
        _description = description,
        _creatorOfGroup = creatorOfGroup,
        _admins = admins,
        _groupChatRoomId = groupChatRoomId;

  Map<String, dynamic> toMap() {
    return {
      'groupName': _groupName,
      'description': _description,
      'groupChatRoomId': _groupChatRoomId,
      'members': _members.map((user) => user.toMap()).toList(),
      'creatorOfGroup': _creatorOfGroup.toMap(),
      'admins': _admins.map((user) => user.toMap()).toList(),
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

  String getDescription() {
    return _description;
  }

  void setDescription(String description) {
    _description = description;
  }

  BcUser getCreatorOfGroup() {
    return _creatorOfGroup;
  }

  void setCreatorOfGroup(BcUser creator) {
    _creatorOfGroup = creator;
  }

  List<BcUser> getAdmins() {
    return _admins;
  }

  void setAdmins(List<BcUser> admins) {
    _admins = admins;
  }

  String getGroupChatRoomId() {
    return _groupChatRoomId;
  }

  void setGroupChatRoomId(String id) {
    _groupChatRoomId = id;
  }
}
