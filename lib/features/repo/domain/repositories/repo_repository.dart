import 'package:github_app/features/repo/data/models/list_repo_model.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/shared/utils/api_response.dart';

abstract interface class RepoRepository {
  Future<APIResponse<List<Repo>>> getAllRepositoriesByUsername(String username);
  Future<APIResponse<ListRepo>> getTopRepositories();
}
