import 'package:github_app/features/repo/data/models/list_repo_model.dart';
import 'package:github_app/features/repo/domain/repositories/repo_repository.dart';
import 'package:github_app/shared/utils/api_response.dart';

class GetTopRepositoriesUseCase {
  final RepoRepository repository;

  GetTopRepositoriesUseCase(this.repository);

  Future<APIResponse<ListRepo>> call() {
    return repository.getTopRepositories();
  }
}
