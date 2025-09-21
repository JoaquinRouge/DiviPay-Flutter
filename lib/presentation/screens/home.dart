import 'package:divipay/core/components/appBar.dart';
import 'package:divipay/core/components/bottomAppBar.dart';
import 'package:divipay/core/components/groupCard.dart';
import 'package:divipay/domain/Group.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final List<Group> groups = Group.getGroups();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          childAspectRatio: 1.9,
          crossAxisCount: 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [GroupCard(group:groups[0]),GroupCard(group:groups[1])],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
