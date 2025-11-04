// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      login: json['login'] as String,
      id: (json['id'] as num).toInt(),
      avatarUrl: json['avatar_url'] as String,
      htmlUrl: json['html_url'] as String,
      type: json['type'] as String,
      followers: (json['followers'] as num?)?.toInt(),
      following: (json['following'] as num?)?.toInt(),
      location: json['location'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'login': instance.login,
      'id': instance.id,
      'avatar_url': instance.avatarUrl,
      'html_url': instance.htmlUrl,
      'type': instance.type,
      'followers': instance.followers,
      'following': instance.following,
      'location': instance.location,
    };
