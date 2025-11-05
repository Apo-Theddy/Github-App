import 'package:flutter/material.dart';
import 'package:github_app/core/color/app_color.dart';
import 'package:go_router/go_router.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(AppColor.secondary),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_back_ios, size: 20),
      ),
    );
  }
}
