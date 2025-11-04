import 'package:github_app/features/repo/domain/repositories/favorite_repo_repository.dart';

class AddFavoriteRepoIdUsecase {
  final FavoriteRepoRepository repository;

  AddFavoriteRepoIdUsecase(this.repository);

  Future<void> call(int repoId) async {
    await repository.addFavoriteRepoId(repoId);
  }
}
