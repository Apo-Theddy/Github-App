import 'package:flutter/material.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/presentation/pages/profile_user_card.dart';
import 'package:github_app/shared/widgets/back_button_widget.dart';

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
          padding: EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  BackButtonWidget(),
                  const SizedBox(width: 16),
                  const Text(
                    'User Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined),
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
