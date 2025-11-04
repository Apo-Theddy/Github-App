import 'package:dio/dio.dart';
import 'package:github_app/core/errors/api_failure.dart';
import 'package:github_app/features/repo/data/models/list_repo_model.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';

abstract interface class RepoRemoteDatasource {
  Future<List<Repo>> getAllRepositoriesByUsername(String username);
  Future<ListRepo> getTopRepositories();
}

class RepoRemoteDataSourceImpl extends RepoRemoteDatasource {
  final Dio dio;

  RepoRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Repo>> getAllRepositoriesByUsername(String username) async {
    try {
      final response = await dio.get("/users/$username/repos");
      final List<Repo> repos = (response.data as List)
          .map((repoData) => Repo.fromJson(repoData))
          .toList();
      return repos;
    } on DioException catch (err) {
      throw APIFailure(
        err.message ?? "Internal Server Error",
        err.response?.statusCode ?? 500,
      );
    }
  }

  @override
  Future<ListRepo> getTopRepositories() async {
    try {
      final response = await dio.get(
        'search/repositories?q=stars:>1&sort=stars',
      );
      return ListRepo.fromJson(response.data);
    } on DioException catch (err) {
      throw APIFailure(
        err.message ?? "Internal Server Error",
        err.response?.statusCode ?? 500,
      );
    }
  }
}
