import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part "user_model.g.dart";

@JsonSerializable()
class User extends Equatable {
  final String login;
  final int id;
  @JsonKey(name: "avatar_url")
  final String avatarUrl;
  @JsonKey(name: "html_url")
  final String htmlUrl;
  final String type;
  final int? followers;
  final int? following;
  final String? location;

  const User({
    required this.login,
    required this.id,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.type,
    this.followers,
    this.following,
    this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [
    login,
    id,
    avatarUrl,
    htmlUrl,
    type,
    followers,
    following,
    location,
  ];
}
