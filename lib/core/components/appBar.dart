import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      title: Image.asset("assets/images/logo-white.png", width: 100),
    );
  }
}