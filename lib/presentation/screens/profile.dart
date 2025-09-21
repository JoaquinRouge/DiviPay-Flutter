import 'package:divipay/core/components/appBar.dart';
import 'package:divipay/core/components/bottomAppBar.dart';
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