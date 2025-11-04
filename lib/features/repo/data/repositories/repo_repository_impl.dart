import 'package:dartz/dartz.dart';
import 'package:github_app/core/errors/api_failure.dart';
import 'package:github_app/features/repo/data/datasources/remote/repo_remote_datasource.dart';
import 'package:github_app/features/repo/data/models/list_repo_model.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/domain/repositories/repo_repository.dart';
import 'package:github_app/shared/utils/api_response.dart';

class RepoRepositoryImpl implements RepoRepository {
  final RepoRemoteDatasource datasource;

  RepoRepositoryImpl(this.datasource);

  @override
  Future<APIResponse<List<Repo>>> getAllRepositoriesByUsername(
    String username,
  ) async {
    try {
      final repos = await datasource.getAllRepositoriesByUsername(username);
      return right(repos);
    } on APIFailure catch (e) {
      return left(APIFailure(e.message, e.code));
    }
  }

  @override
  Future<APIResponse<ListRepo>> getTopRepositories() async {
    try {
      final listRepo = await datasource.getTopRepositories();
      return right(listRepo);
    } on APIFailure catch (e) {
      return left(APIFailure(e.message, e.code));
    }
  }
}
