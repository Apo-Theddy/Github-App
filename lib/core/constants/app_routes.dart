import 'package:flutter/cupertino.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/presentation/pages/favorite_repos_page.dart';
import 'package:github_app/features/repo/presentation/pages/repo_detail_page.dart';
import 'package:github_app/features/repo/presentation/pages/user_detail_page.dart';
import 'package:github_app/features/splash_screen/presentation/pages/splash_screen_page.dart';
import 'package:github_app/home_page.dart';
import 'package:go_router/go_router.dart';

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
      builder: (context, state) {
        return SplashScreenPage();
      },
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
        final repo = state.extra as Repo?;
        if (repo == null) {
          throw ArgumentError('Requires a Repo object for this route');
        }

        return _buildCupertinoPage(
          state: state,
          child: UserDetailPage(repo: repo),
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
        return _buildCupertinoPage(
          state: state,
          child: RepoDetailPage(repo: repo),
        );
      },
    ),
    GoRoute(
      path: favoriteRepos,
      name: 'favoriteRepos',
      pageBuilder: (context, state) =>
          _buildCupertinoPage(state: state, child: const FavoriteReposPage()),
    ),
  ];

  static CustomTransitionPage _buildCupertinoPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: _transitionDuration,
      reverseTransitionDuration: _transitionDuration,
      transitionsBuilder: _cupertinoTransitionBuilder,
    );
  }

  static Widget _cupertinoTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return CupertinoPageTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: true,
      child: child,
    );
  }
}

extension NavigationExtension on BuildContext {
  void goHome() {
    go(AppRoutes.home);
  }

  void goToUserDetail(Repo repo) {
    push(AppRoutes.userDetail, extra: repo);
  }

  void goToRepoDetail(Repo repo) {
    push(AppRoutes.repoDetail, extra: repo);
  }

  void goToFavoriteRepos() {
    push(AppRoutes.favoriteRepos);
  }
}
