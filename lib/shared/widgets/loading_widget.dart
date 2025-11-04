import 'package:flutter/material.dart';
import 'package:github_app/core/color/app_color.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: size.height * 0.3),
          CircularProgressIndicator(color: Color(AppColor.color1)),
          SizedBox(height: 10),
          Text('Loading...'),
        ],
      ),
    );
  }
}
