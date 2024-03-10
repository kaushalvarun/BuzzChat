// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BcUser _$BcUserFromJson(Map<String, dynamic> json) => BcUser(
      username: json['username'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      groups:
          (json['groups'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$BcUserToJson(BcUser instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'status': instance.status,
      'groups': instance.groups,
    };
