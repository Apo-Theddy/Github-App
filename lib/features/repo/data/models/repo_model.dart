import "package:equatable/equatable.dart";
import "package:github_app/features/repo/data/models/owner_model.dart";
import "package:json_annotation/json_annotation.dart";

part "repo_model.g.dart";

@JsonSerializable()
class Repo extends Equatable {
  final int id;
  final String name;
  @JsonKey(name: 'full_name')
  final String fullName;
  final Owner owner;
  @JsonKey(name: 'html_url')
  final String htmlUrl;
  final String? description;
  final bool fork;
  @JsonKey(name: 'forks_count')
  final int forksCount;
  @JsonKey(name: 'stargazers_count')
  final int stargazersCount;
  @JsonKey(name: 'watchers_count')
  final int watchersCount;
  final String? language;

  const Repo({
    required this.id,
    required this.name,
    required this.fullName,
    required this.owner,
    required this.htmlUrl,
    this.description,
    required this.fork,
    required this.forksCount,
    required this.stargazersCount,
    required this.watchersCount,
    this.language,
  });

  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);
  Map<String, dynamic> toJson() => _$RepoToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    fullName,
    owner,
    htmlUrl,
    description,
    fork,
    forksCount,
    stargazersCount,
    watchersCount,
    language,
  ];
}
