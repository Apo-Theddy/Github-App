import 'package:flutter/material.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/presentation/pages/profile_user_card.dart';

class UserDetailPage extends StatefulWidget {
  final Repo repo;
  const UserDetailPage({super.key, required this.repo});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),

          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.share_outlined),
                  ),
                ],
              ),
              ProfileUserCard(owner: widget.repo.owner),
            ],
          ),
        ),
      ),
    );
  }
}
