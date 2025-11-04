import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/features/repo/domain/usecases/add_favorite_repo_id_usecase.dart';
import 'package:github_app/features/repo/domain/usecases/get_favorite_repo_ids_usecase.dart';
import 'package:github_app/features/repo/domain/usecases/remove_favorite_repo_id_usecase.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_event.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_state.dart';

class FavoriteRepoBloc extends Bloc<FavoriteRepoEvent, FavoriteRepoState> {
  final GetFavoriteRepoIdsUsecase getFavoriteRepoIdsUsecase;
  final AddFavoriteRepoIdUsecase addFavoriteRepoIdUsecase;
  final RemoveFavoriteRepoIdUsecase removeFavoriteRepoIdUsecase;

  static FavoriteRepoBloc of(BuildContext context) =>
      BlocProvider.of<FavoriteRepoBloc>(context);

  FavoriteRepoBloc({
    required this.getFavoriteRepoIdsUsecase,
    required this.addFavoriteRepoIdUsecase,
    required this.removeFavoriteRepoIdUsecase,
  }) : super(FavoriteRepoInitialState()) {
    on<AddFavoriteRepoIdEvent>(_addFavoriteEventHandler);
    on<RemoveFavoriteRepoIdEvent>(_removeFavoriteEventHandler);
    on<GetFavoriteRepoIdsEvent>(_getFavoritiesEventHandler);
  }

  Future<void> _addFavoriteEventHandler(
    AddFavoriteRepoIdEvent event,
    Emitter<FavoriteRepoState> emit,
  ) async {
    List<int> currentIds = [];
    if (state is FavoriteRepoLoadedState) {
      currentIds = List.from((state as FavoriteRepoLoadedState).ids);
    }
    if (!currentIds.contains(event.repoId)) {
      currentIds.add(event.repoId);
      await addFavoriteRepoIdUsecase(event.repoId);
      emit(FavoriteRepoLoadedState(currentIds));
    }
  }

  Future<void> _removeFavoriteEventHandler(
    RemoveFavoriteRepoIdEvent event,
    Emitter<FavoriteRepoState> emit,
  ) async {
    List<int> currentIds = [];
    if (state is FavoriteRepoLoadedState) {
      currentIds = List.from((state as FavoriteRepoLoadedState).ids);
    }
    if (currentIds.contains(event.repoId)) {
      currentIds.remove(event.repoId);
      await removeFavoriteRepoIdUsecase(event.repoId);
      emit(FavoriteRepoLoadedState(currentIds));
    }
  }

  Future<void> _getFavoritiesEventHandler(
    GetFavoriteRepoIdsEvent event,
    Emitter<FavoriteRepoState> emit,
  ) async {
    emit(FavoriteRepoLoadingState());
    final favoriteRepoIds = await getFavoriteRepoIdsUsecase();
    emit(FavoriteRepoLoadedState(favoriteRepoIds));
  }
}
