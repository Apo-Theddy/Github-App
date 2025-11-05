import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:github_app/core/color/app_color.dart';
import 'package:github_app/features/repo/data/models/owner_model.dart';
import 'package:github_app/features/repo/di/container.dart';
import 'package:github_app/features/user/data/models/user_model.dart';
import 'package:github_app/shared/widgets/cached_network_image_widget.dart';

class ProfileUserCard extends StatefulWidget {
  const ProfileUserCard({super.key, required this.owner});
  final Owner owner;

  @override
  State<ProfileUserCard> createState() => _ProfileUserCardState();
}

class _ProfileUserCardState extends State<ProfileUserCard> {
  Future<User> _loadUserDetail() async {
    try {
      final response = await sp<Dio>().get("/users/${widget.owner.login}");
      final data = response.data;
      return User.fromJson(data);
    } catch (e) {
      debugPrint("Error loading user detail: $e");
      rethrow;
    }
  }

  Future<String> _loadMarkdownProfile() async {
    if (widget.owner.type != "User") return "";

    try {
      final response = await sp<Dio>().get(
        "/repos/${widget.owner.login}/${widget.owner.login}/readme",
        options: Options(
          validateStatus: (status) => status == 200 || status == 404,
        ),
      );

      if (response.statusCode == 404) return "";
      final data = response.data;
      if (data == null || data["content"] == null) return "";

      final base64String = data["content"] as String;
      final cleaned = base64String.replaceAll('\n', '');
      final bytes = base64.decode(cleaned);
      return utf8.decode(bytes);
    } catch (e) {
      debugPrint("Error loading README: $e");
      return "";
    }
  }

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
                      widget.owner.login,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder(
                      future: _loadUserDetail(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Failed to load user details.",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          );
                        }

                        final user = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_pin, size: 19),
                                const SizedBox(width: 6),
                                Text(user.location ?? 'No location provided'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                FaIcon(FontAwesomeIcons.userGroup, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  "${user.followers}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "followers",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                SizedBox(width: 6),
                                FaIcon(FontAwesomeIcons.user, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  "${user.following}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 6),
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
                        );
                      },
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
                      imageUrl: widget.owner.avatarUrl,
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
                      widget.owner.login,
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

                FutureBuilder<String>(
                  future: _loadMarkdownProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 60,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    if (snapshot.hasError || snapshot.data == null) {
                      return const Text(
                        "Failed to load README.md profile.",
                        style: TextStyle(color: Colors.redAccent),
                      );
                    }

                    final markdownContent = snapshot.data!;
                    if (markdownContent.trim().isEmpty) {
                      return const Text(
                        "This user has no README.md profile.",
                        style: TextStyle(color: Colors.grey),
                      );
                    }

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: MarkdownBody(
                        data: markdownContent,
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
                    );
                  },
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
