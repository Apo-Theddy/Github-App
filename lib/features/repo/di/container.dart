import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:github_app/features/repo/data/datasources/local/favorite_repo_datasource.dart';
import 'package:github_app/features/repo/data/datasources/remote/repo_remote_datasource.dart';
import 'package:github_app/features/repo/data/repositories/favorite_repo_repository_impl.dart';
import 'package:github_app/features/repo/data/repositories/repo_repository_impl.dart';
import 'package:github_app/features/repo/domain/repositories/favorite_repo_repository.dart';
import 'package:github_app/features/repo/domain/repositories/repo_repository.dart';
import 'package:github_app/features/repo/domain/usecases/add_favorite_repo_id_usecase.dart';
import 'package:github_app/features/repo/domain/usecases/get_all_repositories_by_username_usecase.dart';
import 'package:github_app/features/repo/domain/usecases/get_favorite_repo_ids_usecase.dart';
import 'package:github_app/features/repo/domain/usecases/get_top_repositories_usecase.dart';
import 'package:github_app/features/repo/domain/usecases/remove_favorite_repo_id_usecase.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_bloc.dart';
import 'package:github_app/features/repo/presentation/bloc/repo_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

final sp = GetIt.instance;

Future<void> containerDeps() async {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.github.com/",
      headers: {"Authorization": "...token GITHUB_PERSONAL_ACCESS_TOKEN..."},
    ),
  );

  sp.registerSingleton<Dio>(dio);
  sp.registerSingletonAsync(() async {
    await Hive.initFlutter();
    return Hive;
  });

  sp.registerLazySingleton<RepoRemoteDatasource>(
    () => RepoRemoteDataSourceImpl(dio),
  );
  sp.registerLazySingleton<RepoRepository>(() => RepoRepositoryImpl(sp()));
  sp.registerLazySingleton(() => GetAllRepositoriesByUsernameUsecase(sp()));
  sp.registerLazySingleton(() => GetTopRepositoriesUseCase(sp()));
  sp.registerFactory<RepoBloc>(
    () => RepoBloc(
      getAllRepositoriesByUsernameUsecase: sp(),
      getTopRepositoriesUseCase: sp(),
    ),
  );

  await sp.allReady();

  final hive = sp<HiveInterface>();
  sp.registerLazySingleton<FavoriteRepoDataSource>(
    () => FavoriteRepoDataSourceImpl(hive),
  );
  sp.registerLazySingleton<FavoriteRepoRepository>(
    () => FavoriteRepoRepositoryImpl(sp()),
  );
  sp.registerLazySingleton<AddFavoriteRepoIdUsecase>(
    () => AddFavoriteRepoIdUsecase(sp()),
  );
  sp.registerLazySingleton<GetFavoriteRepoIdsUsecase>(
    () => GetFavoriteRepoIdsUsecase(sp()),
  );
  sp.registerLazySingleton<RemoveFavoriteRepoIdUsecase>(
    () => RemoveFavoriteRepoIdUsecase(sp()),
  );
  sp.registerFactory<FavoriteRepoBloc>(
    () => FavoriteRepoBloc(
      getFavoriteRepoIdsUsecase: sp(),
      addFavoriteRepoIdUsecase: sp(),
      removeFavoriteRepoIdUsecase: sp(),
    ),
  );
}
