import 'package:divipay/core/components/appBar.dart';
import 'package:divipay/domain/Group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:divipay/core/components/bottomAppBar.dart';

class Groupdetail extends StatelessWidget {
  const Groupdetail({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(child: Text('Detalles del grupo: ${group.name}')),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
