// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_repo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListRepo _$ListRepoFromJson(Map<String, dynamic> json) => ListRepo(
      totalCount: (json['total_count'] as num).toInt(),
      incompleteResults: json['incomplete_results'] as bool,
      items: (json['items'] as List<dynamic>)
          .map((e) => Repo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListRepoToJson(ListRepo instance) => <String, dynamic>{
      'total_count': instance.totalCount,
      'incomplete_results': instance.incompleteResults,
      'items': instance.items,
    };
