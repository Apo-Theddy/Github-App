import 'package:equatable/equatable.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_repo_model.g.dart';

@JsonSerializable()
class ListRepo extends Equatable {
  @JsonKey(name: 'total_count')
  final int totalCount;
  @JsonKey(name: 'incomplete_results')
  final bool incompleteResults;
  final List<Repo> items;

  const ListRepo({
    required this.totalCount,
    required this.incompleteResults,
    required this.items,
  });

  factory ListRepo.fromJson(Map<String, dynamic> json) =>
      _$ListRepoFromJson(json);

  Map<String, dynamic> toJson() => _$ListRepoToJson(this);

  @override
  List<Object?> get props => [totalCount, incompleteResults, items];
}
