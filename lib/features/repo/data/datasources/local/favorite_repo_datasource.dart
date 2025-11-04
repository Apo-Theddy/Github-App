import 'package:hive_flutter/hive_flutter.dart';

abstract interface class FavoriteRepoDataSource {
  Future<List<int>> getFavoriteRepoIds();
  Future<void> addFavoriteRepoId(int repoId);
  Future<void> removeFavoriteRepoId(int repoId);
}

class FavoriteRepoDataSourceImpl implements FavoriteRepoDataSource {
  final String boxName = "favorite_repos";
  final HiveInterface hive;

  FavoriteRepoDataSourceImpl(this.hive);

  @override
  Future<void> addFavoriteRepoId(int repoId) {
    return hive.openBox(boxName).then((box) => box.put(repoId, true));
  }

  @override
  Future<List<int>> getFavoriteRepoIds() {
    return hive.openBox(boxName).then((box) => box.keys.cast<int>().toList());
  }

  @override
  Future<void> removeFavoriteRepoId(int repoId) {
    return hive.openBox(boxName).then((box) => box.delete(repoId));
  }
}
