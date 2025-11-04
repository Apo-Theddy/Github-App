import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/domain/repositories/repo_repository.dart';
import 'package:github_app/shared/utils/api_response.dart';

class GetAllRepositoriesByUsernameUsecase {
  final RepoRepository repository;

  GetAllRepositoriesByUsernameUsecase(this.repository);

  Future<APIResponse<List<Repo>>> call(String username) {
    return repository.getAllRepositoriesByUsername(username);
  }
}
