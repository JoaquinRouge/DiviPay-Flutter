import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      height: 70,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(right: 18,left: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              navContainer(
                context,
                index == 0 ? FontAwesomeIcons.solidHouse : FontAwesomeIcons.house,
                "Home",
                "/home",
              ),
              navContainer(
                context,
                index == 1 ? FontAwesomeIcons.solidBell : FontAwesomeIcons.bell,
                "Notifications",
                "/home",
              ),
              //navContainer(context,FontAwesomeIcons.,"Friends","/home"),
              navContainer(
                context,
                index == 2 ? FontAwesomeIcons.solidUser : FontAwesomeIcons.user,
                "Profile",
                "/home",
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell navContainer(
    BuildContext context,
    IconData icon,
    String text,
    String route,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        context.go(route);
      },
      child: Column(children: [Icon(icon), Text(text)]),
    );
  }
}
