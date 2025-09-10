import 'package:divipay/core/components/bottomAppBar.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      toolbarHeight: 80,
      backgroundColor: Theme.of(context).primaryColor,
      title: Center(
        child: Image.asset(
          "assets/images/logo-white.png",
          width: 100,
        ),
      )
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      bottomNavigationBar: CustomBottomBar(index: 0,),
    );
  }
}
