import 'package:equatable/equatable.dart';
import 'package:github_app/features/repo/data/models/list_repo_model.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';

abstract class RepoState extends Equatable {}

class RepoInitialState extends RepoState {
  @override
  List<Object?> get props => [];
}

class RepoLoadingState extends RepoState {
  @override
  List<Object?> get props => [];
}

class RepoLoadedState extends RepoState {
  final List<Repo> repos;

  RepoLoadedState(this.repos);

  @override
  List<Object?> get props => [repos];
}

class RepoErrorState extends RepoState {
  final String message;
  final int code;

  RepoErrorState(this.message, this.code);

  @override
  List<Object?> get props => [message];
}

class ListRepoLoadedState extends RepoState {
  final ListRepo repos;

  ListRepoLoadedState(this.repos);

  @override
  List<Object?> get props => [repos];
}
