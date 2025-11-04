abstract interface class FavoriteRepoRepository {
  Future<List<int>> getFavoriteRepoIds();
  Future<void> addFavoriteRepoId(int repoId);
  Future<void> removeFavoriteRepoId(int repoId);
}
