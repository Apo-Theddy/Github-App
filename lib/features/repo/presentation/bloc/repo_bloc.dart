import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/features/repo/domain/usecases/get_all_repositories_by_username_usecase.dart';
import 'package:github_app/features/repo/domain/usecases/get_top_repositories_usecase.dart';
import 'package:github_app/features/repo/presentation/bloc/repo_event.dart';
import 'package:github_app/features/repo/presentation/bloc/repo_state.dart';

class RepoBloc extends Bloc<RepoEvent, RepoState> {
  final GetAllRepositoriesByUsernameUsecase getAllRepositoriesByUsernameUsecase;
  final GetTopRepositoriesUseCase getTopRepositoriesUseCase;

  static RepoBloc of(BuildContext context) =>
      BlocProvider.of<RepoBloc>(context);

  RepoBloc({
    required this.getAllRepositoriesByUsernameUsecase,
    required this.getTopRepositoriesUseCase,
  }) : super(RepoInitialState()) {
    on<GetReposEventByUsername>(_onGetReposByUsername);
    on<GetTopReposEvent>(_onGetTopRepos);
  }

  void _onGetReposByUsername(
    GetReposEventByUsername event,
    Emitter<RepoState> emit,
  ) async {
    emit(RepoLoadingState());
    final result = await getAllRepositoriesByUsernameUsecase(event.username);
    result.fold(
      (failure) => emit(RepoErrorState(failure.message, failure.code)),
      (repos) => emit(RepoLoadedState(repos)),
    );
  }

  void _onGetTopRepos(GetTopReposEvent event, Emitter<RepoState> emit) async {
    emit(RepoLoadingState());
    final result = await getTopRepositoriesUseCase();
    result.fold(
      (failure) => emit(RepoErrorState(failure.message, failure.code)),
      (repos) => emit(ListRepoLoadedState(repos)),
    );
  }
}
