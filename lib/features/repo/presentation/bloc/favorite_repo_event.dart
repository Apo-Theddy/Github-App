import 'package:equatable/equatable.dart';

abstract class FavoriteRepoEvent extends Equatable {}

class LoadFavoriteReposEvent extends FavoriteRepoEvent {
  @override
  List<Object?> get props => [];
}

class AddFavoriteRepoIdEvent extends FavoriteRepoEvent {
  final int repoId;
  AddFavoriteRepoIdEvent(this.repoId);

  @override
  List<Object?> get props => [repoId];
}

class RemoveFavoriteRepoIdEvent extends FavoriteRepoEvent {
  final int repoId;
  RemoveFavoriteRepoIdEvent(this.repoId);

  @override
  List<Object?> get props => [repoId];
}

class GetFavoriteRepoIdsEvent extends FavoriteRepoEvent {
  @override
  List<Object?> get props => [];
}
