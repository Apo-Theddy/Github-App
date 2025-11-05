import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/di/container.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_bloc.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_event.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_state.dart';
import 'package:github_app/shared/widgets/back_button_widget.dart';
import 'package:github_app/shared/widgets/group_repos_widget.dart';
import 'package:github_app/shared/widgets/loading_widget.dart';
import 'package:github_app/gen/assets.gen.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteReposPage extends StatefulWidget {
  const FavoriteReposPage({super.key});

  @override
  State<FavoriteReposPage> createState() => _FavoriteReposPageState();
}

class _FavoriteReposPageState extends State<FavoriteReposPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final Map<int, Repo> _repoCache = {};

  @override
  bool get wantKeepAlive => true;

  Future<Repo> _getRepoById(int id) async {
    if (_repoCache.containsKey(id)) return _repoCache[id]!;
    final response = await sp<Dio>().get('repositories/$id');
    final repo = Repo.fromJson(response.data);
    _repoCache[id] = repo;
    return repo;
  }

  Widget _buildEmptyData(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Assets.images.octocatEmpty.image(width: size.width * 0.5),
          const SizedBox(height: 20),
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButtonWidget(),
                  const SizedBox(width: 16),
                  const Text(
                    'Favorite Repositories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<FavoriteRepoBloc, FavoriteRepoState>(
                builder: (context, state) {
                  if (state is FavoriteRepoLoadedState) {
                    if (state.ids.isEmpty) {
                      return _buildEmptyData(context);
                    }

                    return FutureBuilder<List<Repo>>(
                      future: Future.wait(
                        state.ids.map((id) => _getRepoById(id)),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: LoadingWidget());
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return _buildEmptyData(context);
                        }

                        return GroupReposWidget(
                          repos: snapshot.data!,
                          scrollController: _scrollController,
                          onRemoveFavorite: (id) {
                            context.read<FavoriteRepoBloc>().add(
                              RemoveFavoriteRepoIdEvent(id),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const Center(child: LoadingWidget());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
