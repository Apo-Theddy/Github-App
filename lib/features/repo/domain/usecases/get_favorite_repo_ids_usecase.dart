import 'package:github_app/features/repo/domain/repositories/favorite_repo_repository.dart';

class GetFavoriteRepoIdsUsecase {
  final FavoriteRepoRepository repository;

  GetFavoriteRepoIdsUsecase(this.repository);

  Future<List<int>> call() async {
    return repository.getFavoriteRepoIds();
  }
}
