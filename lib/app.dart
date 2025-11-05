import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/core/constants/app_routes.dart';
import 'package:github_app/core/theme/app_theme.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/di/container.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_bloc.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_event.dart';
import 'package:github_app/features/repo/presentation/bloc/repo_bloc.dart';
import 'package:github_app/features/repo/presentation/bloc/repo_event.dart';
import 'package:github_app/features/repo/presentation/pages/favorite_repos_page.dart';
import 'package:github_app/features/repo/presentation/pages/repo_detail_page.dart';
import 'package:github_app/features/repo/presentation/pages/user_detail_page.dart';
import 'package:github_app/home_page.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  final GoRouter _router = AppRoutes.router;
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sp<RepoBloc>()..add(GetTopReposEvent())),
        BlocProvider(
          create: (_) => sp<FavoriteRepoBloc>()..add(GetFavoriteRepoIdsEvent()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        theme: AppTheme.dark(),
        title: "GitHub App",
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
