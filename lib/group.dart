// ignore_for_file: prefer_initializing_formals
import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  String groupName;
  List<String> members;
  // String description;
  String creatorOfGroup;
  // List<BcUser> admins;
  String groupChatRoomId;

  Group({
    required String groupName,
    required List<String> members,
    // required String description,
    required String creatorOfGroup,
    // required List<BcUser> admins,
    required String groupChatRoomId,
  })  : groupName = groupName,
        members = members,
        // description = description,
        creatorOfGroup = creatorOfGroup,
        // admins = admins,
        groupChatRoomId = groupChatRoomId;

  // fromJson
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  // toJson
  Map<String, dynamic> toJson() => _$GroupToJson(this);

  String getGroupName() {
    return groupName;
  }

  void setGroupName(String name) {
    groupName = name;
  }

  List<String> getMembers() {
    return members;
  }

  void setMembers(List<String> members) {
    members = members;
  }

  // String getDescription() {
  //   return description;
  // }

  // void setDescription(String description) {
  //   description = description;
  // }

  String getCreatorOfGroup() {
    return creatorOfGroup;
  }

  void setCreatorOfGroup(String creator) {
    creatorOfGroup = creator;
  }

  // List<BcUser> getAdmins() {
  //   return admins;
  // }

  // void setAdmins(List<BcUser> admins) {
  //   admins = admins;
  // }

  String getGroupChatRoomId() {
    return groupChatRoomId;
  }

  void setGroupChatRoomId(String id) {
    groupChatRoomId = id;
  }
}
