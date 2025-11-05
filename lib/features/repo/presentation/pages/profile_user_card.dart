import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:github_app/core/color/app_color.dart';
import 'package:github_app/features/repo/data/models/owner_model.dart';
import 'package:github_app/features/user/data/models/user_model.dart';
import 'package:github_app/shared/widgets/cached_network_image_widget.dart';

class ProfileUserCard extends StatelessWidget {
  final Owner owner;
  final User user;
  final String markdown;

  const ProfileUserCard({
    super.key,
    required this.owner,
    required this.user,
    required this.markdown,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.03),

          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: size.width * 0.12,
                  bottom: 16,
                  left: size.width * 0.05,
                  right: size.width * 0.05,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(AppColor.secondary),
                  border: Border.all(color: Colors.grey.shade700, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      owner.login,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_pin, size: 19),
                        const SizedBox(width: 6),
                        Text(user.location ?? 'No location provided'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.userGroup, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          "${user.followers}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "followers",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const FaIcon(FontAwesomeIcons.user, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          "${user.following}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "following",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -size.width * 0.1,
                left: size.width * 0.07,
                child: Container(
                  width: size.width * 0.2,
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImageWidget(
                      imageUrl: owner.avatarUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(AppColor.secondary),
              border: Border.all(color: Colors.grey.shade700, width: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      owner.login,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Text(" / "),
                    const Text(
                      "README.md",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20, thickness: 0.8),
                if (markdown.trim().isEmpty)
                  const Text(
                    "This user has no README.md profile.",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: MarkdownBody(
                      data: markdown,
                      shrinkWrap: true,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 14, height: 1.6),
                        h1: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        h2: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        h3: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        code: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          backgroundColor: Colors.grey[800],
                        ),
                        codeblockPadding: const EdgeInsets.all(12),
                        codeblockDecoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        blockquoteDecoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(4),
                          border: const Border(
                            left: BorderSide(color: Colors.blue, width: 4),
                          ),
                        ),
                        blockquotePadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        tableBorder: TableBorder.all(color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
