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
      height: 70,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                ref.read(pageProvider.notifier).state = '/home';
              },
              child: navItem(context, HeroIcons.home, 'Inicio', '/home', ref),
            ),
            GestureDetector(
              onTap: () {
                ref.read(pageProvider.notifier).state = '/search_users';
              },
              child: navItem(
                context,
                HeroIcons.magnifyingGlass,
                'Encontrar',
                '/search_users',
                ref,
              ),
            ),
            GestureDetector(
              onTap: () {
                ref.read(pageProvider.notifier).state = '/notifications';
              },
              child: notificationListener.when(
                data: (requests) {
                  if (requests.isEmpty) {
                    return navItem(
                      context,
                      HeroIcons.envelope,
                      'Solicitudes',
                      '/notifications',
                      ref,
                    );
                  } else {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        navItem(
                          context,
                          HeroIcons.envelope,
                          'Solicitudes',
                          '/notifications',
                          ref,
                        ),
                        Positioned(
                          right: 15,
                          top: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
                loading: () => navItem(
                  context,
                  HeroIcons.envelope,
                  'Solicitudes',
                  '/notifications',
                  ref,
                ),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
            GestureDetector(
              onTap: () {
                ref.read(pageProvider.notifier).state = '/profile';
              },
              child: navItem(
                context,
                HeroIcons.user,
                'Perfil',
                '/profile',
                ref,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column navItem(
    BuildContext context,
    HeroIcons icon,
    String label,
    String route,
    WidgetRef ref,
  ) {
    bool samePage = ref.watch(pageProvider) == route;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeroIcon(
          icon,
          style: samePage ? HeroIconStyle.solid : HeroIconStyle.outline,
          size: 30,
          color: samePage ? Theme.of(context).primaryColor : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: samePage ? Theme.of(context).primaryColor : Colors.grey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}


//navItem(
//                context,
 //               HeroIcons.envelope,
//                'Solicitudes',
//                '/notifications',
//                ref,
//              ),