import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/core/color/app_color.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_bloc.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_event.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_state.dart';
import 'package:github_app/shared/widgets/back_button_widget.dart';

class RepoDetailPage extends StatefulWidget {
  final Repo repo;
  const RepoDetailPage({super.key, required this.repo});

  @override
  State<RepoDetailPage> createState() => _RepoDetailPageState();
}

class _RepoDetailPageState extends State<RepoDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() {
    final state = context.read<FavoriteRepoBloc>().state;
    if (state is FavoriteRepoLoadedState) {
      setState(() {
        isFavorite = state.ids.contains(widget.repo.id);
      });
    }
  }

  void _toggleFavorite() {
    final state = context.read<FavoriteRepoBloc>().state;
    if (state is FavoriteRepoLoadedState) {
      if (state.ids.contains(widget.repo.id)) {
        setState(() {
          isFavorite = false;
        });
        context.read<FavoriteRepoBloc>().add(
          RemoveFavoriteRepoIdEvent(widget.repo.id),
        );
      } else {
        setState(() {
          isFavorite = true;
        });
        context.read<FavoriteRepoBloc>().add(
          AddFavoriteRepoIdEvent(widget.repo.id),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    'Repository Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Hero(
                    tag: 'avatar_${widget.repo.id}',
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        widget.repo.owner.avatarUrl,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.repo.owner.login,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          widget.repo.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (widget.repo.description?.isNotEmpty == true)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    widget.repo.description!,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              Row(
                children: [
                  _Stat(
                    Icons.star_outline,
                    _formatNum(widget.repo.stargazersCount),
                  ),
                  const SizedBox(width: 20),
                  _Stat(Icons.call_split, _formatNum(widget.repo.forksCount)),
                  const SizedBox(width: 20),
                  _Stat(
                    Icons.remove_red_eye_outlined,
                    _formatNum(widget.repo.watchersCount),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (widget.repo.language != null)
                    _Chip(Icons.code, widget.repo.language!),
                  _Chip(
                    widget.repo.fork ? Icons.call_split : Icons.source,
                    widget.repo.fork ? 'Forked' : 'Original',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.star_rate_rounded : Icons.star_outline,
                    color: isFavorite ? Colors.amber : Colors.grey,
                  ),
                  label: Text(
                    isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNum(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;

  const _Stat(this.icon, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Chip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(AppColor.secondary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
