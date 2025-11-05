import 'package:divipay/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../../provider/page_provider.dart';

class CustomBottomBar extends ConsumerWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(pageProvider, (previous, next) {
      if (next != previous) {
        context.go(next);
      }
    });

    final notificationListener = ref.watch(incomingFriendRequestsProvider);

    return Container(
      height: 75,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade100,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, ref, HeroIcons.home, 'Inicio', '/home'),
              _navItem(context, ref, HeroIcons.magnifyingGlass, 'Encontrar', '/search_users'),
              _notificationItem(context, ref, notificationListener),
              _navItem(context, ref, HeroIcons.user, 'Perfil', '/profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, WidgetRef ref, HeroIcons icon, String label, String route) {
    final bool samePage = ref.watch(pageProvider) == route;

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
      onTap: () => ref.read(pageProvider.notifier).state = route,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeroIcon(
              icon,
              style: samePage ? HeroIconStyle.solid : HeroIconStyle.outline,
              size: 28,
              color: samePage ? Theme.of(context).primaryColor : Colors.grey,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: samePage ? Theme.of(context).primaryColor : Colors.grey,
                fontSize: 11,
                fontWeight: samePage ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationItem(BuildContext context, WidgetRef ref, AsyncValue<List> listener) {
    return listener.when(
      data: (requests) {
        final hasNotifications = requests.isNotEmpty;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _navItem(context, ref, HeroIcons.envelope, 'Solicitudes', '/notifications'),
            if (hasNotifications)
              Positioned(
                right: 12,
                top: -2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => _navItem(context, ref, HeroIcons.envelope, 'Solicitudes', '/notifications'),
      error: (e, _) => const SizedBox(),
    );
  }
}