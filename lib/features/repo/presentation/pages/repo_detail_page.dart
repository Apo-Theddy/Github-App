import 'package:flutter/material.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';

class RepoDetailPage extends StatelessWidget {
  final Repo repo;
  const RepoDetailPage({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [Text("Repo Detail Page")])),
    );
  }
}
