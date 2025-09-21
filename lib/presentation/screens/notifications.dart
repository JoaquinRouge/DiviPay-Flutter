import 'package:divipay/core/components/appBar.dart';
import 'package:flutter/material.dart';
import 'package:divipay/core/components/bottomAppBar.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: const Center(
        child: Text('Notificaciones'),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}