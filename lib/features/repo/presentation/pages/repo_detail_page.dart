import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/core/color/app_color.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_bloc.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_event.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_state.dart';
import 'package:github_app/shared/utils/language_color.dart';
import 'package:github_app/shared/widgets/back_button_widget.dart';
import 'package:github_app/shared/widgets/cached_network_image_widget.dart';

class RepoDetailPage extends StatelessWidget {
  final Repo repo;

  const RepoDetailPage({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const BackButtonWidget(),
                    const SizedBox(width: 8),
                    const Text(
                      'Repository Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    ClipOval(
                      child: CachedNetworkImageWidget(
                        imageUrl: repo.owner.avatarUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            repo.owner.login,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            repo.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (repo.description?.isNotEmpty == true) ...[
                  const SizedBox(height: 24),
                  Text(
                    repo.description!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: theme.textTheme.bodyLarge?.color?.withValues(
                        alpha: 0.85,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      icon: Icons.star_outline,
                      label: _formatNumber(repo.stargazersCount),
                      color: Colors.amber,
                    ),
                    _StatItem(
                      icon: Icons.call_split,
                      label: _formatNumber(repo.forksCount),
                      color: Colors.grey.shade600,
                    ),
                    _StatItem(
                      icon: Icons.remove_red_eye_outlined,
                      label: _formatNumber(repo.watchersCount),
                      color: Colors.blue.shade600,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (repo.language?.isNotEmpty == true)
                      _LanguageChip(language: repo.language!, isDark: isDark),
                    _StatusChip(
                      icon: repo.fork ? Icons.call_split : Icons.source,
                      label: repo.fork ? 'Forked' : 'Original',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                BlocBuilder<FavoriteRepoBloc, FavoriteRepoState>(
                  builder: (context, state) {
                    final isFavorite =
                        state is FavoriteRepoLoadedState &&
                        state.ids.contains(repo.id);

                    return SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          if (isFavorite) {
                            context.read<FavoriteRepoBloc>().add(
                              RemoveFavoriteRepoIdEvent(repo.id),
                            );
                          } else {
                            context.read<FavoriteRepoBloc>().add(
                              AddFavoriteRepoIdEvent(repo.id),
                            );
                          }
                        },
                        icon: Icon(
                          isFavorite
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 20,
                          color: isFavorite ? Colors.amber : Colors.white,
                        ),
                        label: Text(
                          isFavorite
                              ? 'Remove from Favorites'
                              : 'Add to Favorites',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Color(AppColor.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String language;
  final bool isDark;

  const _LanguageChip({required this.language, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = getLanguageColor(language);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 10, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            language,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatusChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
