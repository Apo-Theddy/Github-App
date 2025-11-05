import 'package:flutter/material.dart';
import 'package:github_app/core/constants/app_routes.dart';
import 'package:github_app/features/repo/presentation/pages/repo_page.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "Home",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => context.goToFavoriteRepos(),
                    icon: Icon(Icons.favorite_outline, size: 28),
                  ),
                ],
              ),
              SizedBox(height: 10),
              RepoPage(),
            ],
          ),
        ),
      ),
    );
  }
}
