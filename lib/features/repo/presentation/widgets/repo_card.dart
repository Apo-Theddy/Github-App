import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/core/color/app_color.dart';
import 'package:github_app/core/constants/routes.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_bloc.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_event.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_state.dart';
import 'package:go_router/go_router.dart';

class RepoCard extends StatefulWidget {
  final Repo repo;
  final void Function(int id)? onRemoveFavorite;
  const RepoCard({super.key, required this.repo, this.onRemoveFavorite});

  @override
  State<RepoCard> createState() => _RepoCardState();
}

class _RepoCardState extends State<RepoCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        context.push(Routes.repoDetail, extra: widget.repo);
      },
      child: Container(
        margin: const EdgeInsetsGeometry.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: BoxBorder.all(color: Color(AppColor.color1), width: 0.5),
        ),

        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.push(Routes.userDetail, extra: widget.repo);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: widget.repo.owner.avatarUrl,
                      placeholder: (context, url) => CircularProgressIndicator(
                        color: Color(AppColor.color1),
                      ),
                      errorWidget: (context, url, error) => Hero(
                        tag: 'avatar_${widget.repo.id}',
                        child: Icon(Icons.account_circle, size: 35),
                      ),
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: size.width * 0.5,
                  child: Text(
                    widget.repo.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                BlocBuilder<FavoriteRepoBloc, FavoriteRepoState>(
                  builder: (context, state) {
                    bool isFavorite = false;
                    if (state is FavoriteRepoLoadedState) {
                      isFavorite = state.ids.contains(widget.repo.id);
                    }
                    return GestureDetector(
                      onTap: () {
                        if (isFavorite) {
                          context.read<FavoriteRepoBloc>().add(
                            RemoveFavoriteRepoIdEvent(widget.repo.id),
                          );

                          if (widget.onRemoveFavorite != null) {
                            widget.onRemoveFavorite!(widget.repo.id);
                          }
                        } else {
                          context.read<FavoriteRepoBloc>().add(
                            AddFavoriteRepoIdEvent(widget.repo.id),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(AppColor.color1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isFavorite ? Colors.amber : Colors.white,
                          size: 16,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              widget.repo.description ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.star_outline, size: 20, color: Colors.amber),
                SizedBox(width: 4),
                Text(
                  '${widget.repo.stargazersCount}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 16),
                Icon(Icons.call_split, size: 20, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  '${widget.repo.forksCount}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  widget.repo.language ?? 'Unknown',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
