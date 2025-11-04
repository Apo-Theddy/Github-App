// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repo _$RepoFromJson(Map<String, dynamic> json) => Repo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
      htmlUrl: json['html_url'] as String,
      description: json['description'] as String?,
      fork: json['fork'] as bool,
      forksCount: (json['forks_count'] as num).toInt(),
      stargazersCount: (json['stargazers_count'] as num).toInt(),
      watchersCount: (json['watchers_count'] as num).toInt(),
      language: json['language'] as String?,
    );

Map<String, dynamic> _$RepoToJson(Repo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'full_name': instance.fullName,
      'owner': instance.owner,
      'html_url': instance.htmlUrl,
      'description': instance.description,
      'fork': instance.fork,
      'forks_count': instance.forksCount,
      'stargazers_count': instance.stargazersCount,
      'watchers_count': instance.watchersCount,
      'language': instance.language,
    };
