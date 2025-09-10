import 'package:go_router/go_router.dart';
import '../presentation/screens/login.dart';
import '../presentation/screens/home.dart';

final GoRouter routerApp = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(path: "/login", builder: (context, state) => Login()),
    GoRoute(
      path: "/home",
      builder: (context, state) {
        return Home();
      },
    ),
  ],
);
