import 'package:divipay/core/components/app_bar.dart';
import 'package:divipay/core/components/bottom_app_bar.dart';
import 'package:divipay/core/domain/FriendRequest.dart';
import 'package:divipay/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class Notifications extends ConsumerWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomingRequests = ref.watch(incomingFriendRequestsProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: incomingRequests.when(
        data: (requests) {
          if (requests.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeroIcon(HeroIcons.envelope, size: 80, color: Colors.grey[400],),
                const SizedBox(height: 16),
                Text(
                  "No tienes solicitudes pendientes",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  "Cuando alguien te envíe una solicitud, aparecerá aquí.",
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: friendRequestCard(req, ref, context),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Align friendRequestCard(
    FriendRequest req,
    WidgetRef ref,
    BuildContext context,
  ) {
    final username = ref.read(userServiceProvider).getById(req.from);

    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.person, color: Colors.white, size: 28),
              ),

              const SizedBox(width: 16),
              Expanded(
                child: FutureBuilder(
                  future: username,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Cargando...',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      );
                    } else {
                      return Text(
                        snapshot.data?.username ?? 'Usuario desconocido',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      );
                    }
                  },
                ),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  ref.read(userServiceProvider).acceptFriendRequest(req.uid);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Solicitud de amistad aceptada',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior
                          .floating, // para que "flote" sobre la UI
                      margin: EdgeInsets.all(
                        16,
                      ), // margen alrededor si usás behavior floating
                      duration: Duration(seconds: 3), // cuánto dura visible
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                child: const HeroIcon(HeroIcons.userPlus, size: 22),
              ),

              const SizedBox(width: 10),

              IconButton(
                onPressed: () {
                  ref.read(userServiceProvider).declineFriendRequest(req.uid);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Solicitud de amistad rechazada',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior
                          .floating, // para que "flote" sobre la UI
                      margin: EdgeInsets.all(
                        16,
                      ), // margen alrededor si usás behavior floating
                      duration: Duration(seconds: 3), // cuánto dura visible
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                icon: const HeroIcon(HeroIcons.xCircle, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
