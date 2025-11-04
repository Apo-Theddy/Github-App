import 'package:equatable/equatable.dart';

abstract class RepoEvent extends Equatable {}

class GetReposEventByUsername extends RepoEvent {
  final String username;

  GetReposEventByUsername(this.username);

  @override
  List<Object?> get props => [username];
}

class GetTopReposEvent extends RepoEvent {
  @override
  List<Object?> get props => [];
}
