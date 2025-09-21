import 'package:divipay/core/components/appBar.dart';
import 'package:divipay/core/components/bottomAppBar.dart';
import 'package:divipay/core/components/groupCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:divipay/provider/groupsProvider.dart';

class Home extends ConsumerWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          childAspectRatio: 1.9,
          crossAxisCount: 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            ...groups.map((group) => GroupCard(group: group)).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 6,
        onPressed: () {},
        child: const Icon(Icons.add), // ícono dentro del botón
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
