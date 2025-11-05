import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/di/container.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_bloc.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_event.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_state.dart';
import 'package:github_app/gen/assets.gen.dart';
import 'package:github_app/shared/widgets/back_button_widget.dart';
import 'package:github_app/shared/widgets/group_repos_widget.dart';
import 'package:github_app/shared/widgets/loading_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteReposPage extends StatefulWidget {
  const FavoriteReposPage({super.key});

  @override
  State<FavoriteReposPage> createState() => _FavoriteReposPageState();
}

class _FavoriteReposPageState extends State<FavoriteReposPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  List<Repo> _favoriteReposData = [];
  final Map<int, Repo> _repoCache = {};
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteRepos();
  }

  Future<Repo> _getRepoById(int id) async {
    if (_repoCache.containsKey(id)) {
      return _repoCache[id]!;
    }

    final response = await sp<Dio>().get('repositories/$id');
    return Repo.fromJson(response.data);
  }

  Future<void> _loadFavoriteRepos() async {
    final state = context.read<FavoriteRepoBloc>().state;
    if (state is FavoriteRepoLoadedState && state.ids.isNotEmpty) {
      if (!mounted) return;
      setState(() => _isLoading = true);
      _favoriteReposData = await Future.wait(
        eagerError: false,
        state.ids.map((id) => _getRepoById(id)),
      );
      setState(() => _isLoading = false);
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _removeFavorite(int id) {
    setState(() {
      _favoriteReposData.removeWhere((repo) => repo.id == id);
    });
    context.read<FavoriteRepoBloc>().add(RemoveFavoriteRepoIdEvent(id));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButtonWidget(),
                  const SizedBox(width: 16),
                  const Text(
                    'Favorite Repsitories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: LoadingWidget());
    }

    if (_favoriteReposData.isEmpty) {
      return _buildEmptyData();
    }

    return GroupReposWidget(
      repos: _favoriteReposData,
      scrollController: _scrollController,
      onRemoveFavorite: _removeFavorite,
    );
  }

  Widget _buildEmptyData() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 60),
          Assets.images.octocatEmpty.image(width: size.width * 0.5),
          SizedBox(height: 20),
          Text(
            'No favorite repositories found.',
            textAlign: TextAlign.center,
            style: GoogleFonts.sedgwickAve(
              fontSize: size.width * 0.07,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
