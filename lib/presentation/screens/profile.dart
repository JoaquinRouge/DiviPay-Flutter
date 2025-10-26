import 'dart:math';
import 'package:divipay/core/components/app_bar.dart';
import 'package:divipay/core/components/bottom_app_bar.dart';
import 'package:divipay/core/components/dialogs/logout_dialog.dart';
import 'package:divipay/provider/user_provider.dart';
import 'package:divipay/widgets/modal/change_password_modal.dart';
import 'package:divipay/widgets/modal/change_username_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsIds = ref.read(userServiceProvider).getFriendsIds();

    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final user = ref.watch(userServiceProvider).getById(currentUserUid);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future: user,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final user = snapshot.data!;
                  return Column(
                    children: [
                      Container(
                        width: 350,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 233, 233, 235),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(25),
                          child: buildUserInfo(user.username, user.email),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 233, 233, 235),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(
                                      context,
                                    ).viewInsets.bottom,
                                  ),
                                  child: ChangeUsernameModal(),
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              HeroIcon(HeroIcons.user, size: 30),
                              SizedBox(width: 10),
                              Text(
                                "Cambiar nombre de usuario",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 400,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 233, 233, 235),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(
                                      context,
                                    ).viewInsets.bottom,
                                  ),
                                  child: ChangePasswordModal(),
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              HeroIcon(HeroIcons.lockClosed, size: 30),
                              SizedBox(width: 10),
                              Text(
                                "Cambiar contraseña",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 400,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              HeroIcon(HeroIcons.userGroup, size: 30),
                              SizedBox(width: 10),
                              Text(
                                "Ver lista de amigos",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 176, 49, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    LogoutDialog.show(context);
                  },
                  child: Text("Cerrar Sesión", style: TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}

Widget buildUserInfo(String username, String email) {
  Color _colorFromName(String name) {
    final random = Random(name.hashCode);
    final hue = random.nextInt(360);
    return HSLColor.fromAHSL(1, hue.toDouble(), 0.45, 0.55).toColor();
  }

  final color = _colorFromName(username);

  return Column(
    children: [
      CircleAvatar(
        radius: 70,
        backgroundColor: color.withOpacity(0.9),
        child: Text(
          username[0].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 50,
          ),
        ),
      ),
      const SizedBox(height: 4),
      SizedBox(
        child: Text(
          username,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        child: Text(
          email,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
