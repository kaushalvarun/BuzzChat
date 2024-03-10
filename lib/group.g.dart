// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      groupName: json['groupName'] as String,
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
      creatorOfGroup: json['creatorOfGroup'] as String,
      groupChatRoomId: json['groupChatRoomId'] as String,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'groupName': instance.groupName,
      'members': instance.members,
      'creatorOfGroup': instance.creatorOfGroup,
      'groupChatRoomId': instance.groupChatRoomId,
    };
