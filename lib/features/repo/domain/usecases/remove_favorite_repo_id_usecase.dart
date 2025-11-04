import 'package:github_app/features/repo/domain/repositories/favorite_repo_repository.dart';

class RemoveFavoriteRepoIdUsecase {
  final FavoriteRepoRepository repository;

  RemoveFavoriteRepoIdUsecase(this.repository);

  Future<void> call(int repoId) async {
    await repository.removeFavoriteRepoId(repoId);
  }
}
