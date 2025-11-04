import 'package:flutter/material.dart';
import 'package:github_app/core/color/app_color.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/presentation/widgets/repo_card.dart';

class GroupReposWidget extends StatelessWidget {
  final List<Repo> repos;
  final ScrollController scrollController;
  final void Function(int id)? onRemoveFavorite; // callback opcional

  const GroupReposWidget({
    super.key,
    required this.repos,
    required this.scrollController,
    this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(AppColor.color1), width: 1),
        color: Color(AppColor.secondary),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        controller: scrollController,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: repos.length,
        itemBuilder: (context, index) {
          final repo = repos[index];
          return RepoCard(
            key: ValueKey(repo.id),
            repo: repo,
            onRemoveFavorite: onRemoveFavorite, // pasar callback
          );
        },
      ),
    );
  }
}
