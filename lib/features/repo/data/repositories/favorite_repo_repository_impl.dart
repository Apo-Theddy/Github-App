import 'package:github_app/features/repo/data/datasources/local/favorite_repo_datasource.dart';
import 'package:github_app/features/repo/domain/repositories/favorite_repo_repository.dart';

class FavoriteRepoRepositoryImpl implements FavoriteRepoRepository {
  final FavoriteRepoDataSource datasource;

  FavoriteRepoRepositoryImpl(this.datasource);

  @override
  Future<List<int>> getFavoriteRepoIds() async {
    return await datasource.getFavoriteRepoIds();
  }

  @override
  Future<void> addFavoriteRepoId(int repoId) async {
    await datasource.addFavoriteRepoId(repoId);
  }

  @override
  Future<void> removeFavoriteRepoId(int repoId) async {
    await datasource.removeFavoriteRepoId(repoId);
  }
}
