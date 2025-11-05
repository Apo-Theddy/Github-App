import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:github_app/core/color/app_color.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/di/container.dart';
import 'package:github_app/features/repo/presentation/pages/favorite_repos_page.dart';
import 'package:github_app/features/repo/presentation/pages/repo_detail_page.dart';
import 'package:github_app/features/repo/presentation/pages/user_detail_page.dart';
import 'package:github_app/features/splash_screen/presentation/pages/splash_screen_page.dart';
import 'package:github_app/home_page.dart';
import 'package:go_router/go_router.dart';
import 'package:github_app/features/user/data/models/user_model.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String userDetail = '/user-detail';
  static const String repoDetail = '/repo-detail';
  static const String favoriteRepos = '/favorite-repos';

  static const Duration _transitionDuration = Duration(milliseconds: 100);

  static GoRouter get router =>
      GoRouter(initialLocation: splash, routes: _routes);

  static final List<RouteBase> _routes = [
    GoRoute(
      path: splash,
      name: 'splash',
      builder: (context, state) => SplashScreenPage(),
    ),
    GoRoute(
      path: home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: userDetail,
      name: 'userDetail',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        if (extras == null) throw ArgumentError('Missing data for userDetail');

        final repo = extras['repo'] as Repo;
        final user = extras['user'] as User;
        final markdown = extras['markdown'] as String;

        return _buildFadePage(
          state: state,
          child: UserDetailPage(repo: repo, user: user, markdown: markdown),
        );
      },
    ),
    GoRoute(
      path: repoDetail,
      name: 'repoDetail',
      pageBuilder: (context, state) {
        final repo = state.extra as Repo?;
        if (repo == null) {
          throw ArgumentError('Requires a Repo object for this route');
        }
        return _buildFadePage(
          state: state,
          child: RepoDetailPage(repo: repo),
        );
      },
    ),
    GoRoute(
      path: favoriteRepos,
      name: 'favoriteRepos',
      pageBuilder: (context, state) =>
          _buildFadePage(state: state, child: const FavoriteReposPage()),
    ),
  ];

  static CustomTransitionPage _buildFadePage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: _transitionDuration,
      reverseTransitionDuration: _transitionDuration,
      transitionsBuilder: _fadeTransitionBuilder,
    );
  }

  static Widget _fadeTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

extension NavigationExtension on BuildContext {
  void goHome() {
    FocusManager.instance.primaryFocus?.unfocus();
    go(AppRoutes.home);
  }

  Future<void> goToUserDetail(Repo repo) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final dio = sp<Dio>();
      final ownerLogin = repo.owner.login;

      final results = await Future.wait([
        dio.get("/users/$ownerLogin"),
        dio.get(
          "/repos/$ownerLogin/$ownerLogin/readme",
          options: Options(validateStatus: (s) => s == 200 || s == 404),
        ),
      ]);

      final userResponse = results[0];
      final readmeResponse = results[1];

      final user = User.fromJson(userResponse.data);
      String markdown = "";
      if (readmeResponse.statusCode == 200 &&
          readmeResponse.data?["content"] != null) {
        final base64String = readmeResponse.data["content"] as String;
        markdown = utf8.decode(
          base64.decode(base64String.replaceAll('\n', '')),
        );
      }

      push(
        AppRoutes.userDetail,
        extra: {'repo': repo, 'user': user, 'markdown': markdown},
      );
    } on DioException catch (e) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to load user details: ${e.response?.data?["message"] ?? e.message}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(AppColor.secondary),
        ),
      );
    }
  }

  void goToRepoDetail(Repo repo) {
    FocusManager.instance.primaryFocus?.unfocus();
    push(AppRoutes.repoDetail, extra: repo);
  }

  void goToFavoriteRepos() {
    FocusManager.instance.primaryFocus?.unfocus();
    push(AppRoutes.favoriteRepos);
  }
}
