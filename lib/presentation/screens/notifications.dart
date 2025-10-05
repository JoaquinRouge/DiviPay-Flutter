import 'package:divipay/core/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:divipay/core/components/bottom_app_bar.dart';

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