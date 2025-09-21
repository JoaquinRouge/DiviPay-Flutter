import 'package:divipay/domain/Group.dart';
import 'package:divipay/presentation/screens/groupDetail.dart';
import 'package:divipay/presentation/screens/notifications.dart';
import 'package:divipay/presentation/screens/profile.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/login.dart';
import '../presentation/screens/home.dart';
import 'package:flutter/material.dart';

Page<dynamic> noTransitionPage(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child; // 👈 sin animación
    },
  );
}

final GoRouter routerApp = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(
      path: "/login",
      pageBuilder: (context, state) => noTransitionPage(Login(), state),
    ),
    GoRoute(
      path: "/home",
      pageBuilder: (context, state) => noTransitionPage(Home(), state),
    ),
    GoRoute(
      path: "/detail",
      pageBuilder: (context, state) {
        final group = state.extra as Group;
        return noTransitionPage(Groupdetail(group: group), state);
      },
    ),
    GoRoute(
      path: "/notifications",
      pageBuilder: (context, state) => noTransitionPage(Notifications(), state),
    ),
    GoRoute(
      path: "/profile",
      pageBuilder: (context, state) => noTransitionPage(Profile(), state),
    ),
  ],
);
