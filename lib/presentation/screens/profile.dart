import 'package:divipay/core/components/app_bar.dart';
import 'package:divipay/core/components/bottom_app_bar.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text("Profile center"),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}