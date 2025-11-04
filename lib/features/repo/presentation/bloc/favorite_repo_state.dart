import 'package:equatable/equatable.dart';

abstract class FavoriteRepoState extends Equatable {}

class FavoriteRepoInitialState extends FavoriteRepoState {
  @override
  List<Object?> get props => [];
}

class FavoriteRepoLoadingState extends FavoriteRepoState {
  @override
  List<Object?> get props => [];
}

class FavoriteRepoLoadedState extends FavoriteRepoState {
  final List<int> ids;
  FavoriteRepoLoadedState(this.ids);

  @override
  List<Object?> get props => [ids];
}

class FavoriteRepoErrorState extends FavoriteRepoState {
  final String message;
  FavoriteRepoErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
