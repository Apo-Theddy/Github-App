import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/core/color/app_color.dart';
import 'package:github_app/core/constants/app_routes.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_bloc.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_event.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_state.dart';
import 'package:github_app/shared/utils/language_color.dart';
import 'package:github_app/shared/widgets/cached_network_image_widget.dart';
import 'package:go_router/go_router.dart';

class RepoCard extends StatelessWidget {
  final Repo repo;
  final void Function(int id)? onRemoveFavorite;

  const RepoCard({super.key, required this.repo, this.onRemoveFavorite});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.goToRepoDetail(repo),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.goToUserDetail(repo),
                    child: ClipOval(
                      child: CachedNetworkImageWidget(
                        imageUrl: repo.owner.avatarUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repo.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (repo.owner.login.isNotEmpty)
                          Text(
                            repo.owner.login,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  BlocBuilder<FavoriteRepoBloc, FavoriteRepoState>(
                    builder: (context, state) {
                      final isFavorite =
                          state is FavoriteRepoLoadedState &&
                          state.ids.contains(repo.id);

                      return IconButton(
                        onPressed: () {
                          if (isFavorite) {
                            context.read<FavoriteRepoBloc>().add(
                              RemoveFavoriteRepoIdEvent(repo.id),
                            );
                            onRemoveFavorite?.call(repo.id);
                          } else {
                            context.read<FavoriteRepoBloc>().add(
                              AddFavoriteRepoIdEvent(repo.id),
                            );
                          }
                        },
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isFavorite ? Colors.amber : null,
                        ),
                        splashRadius: 20,
                      );
                    },
                  ),
                ],
              ),
              if (repo.description?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Text(
                  repo.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.star_border,
                    label: '${repo.stargazersCount}',
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 16),
                  _InfoChip(
                    icon: Icons.call_split,
                    label: '${repo.forksCount}',
                    color: Colors.grey.shade600,
                  ),
                  const Spacer(),
                  if (repo.language?.isNotEmpty == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getLanguageColor(repo.language!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        repo.language!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
