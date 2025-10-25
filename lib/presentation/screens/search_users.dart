import 'package:divipay/core/components/app_bar.dart';
import 'package:divipay/domain/User.dart';
import 'package:divipay/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:divipay/core/components/bottom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class SearchUsers extends ConsumerStatefulWidget {
  const SearchUsers({super.key});

  @override
  ConsumerState<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends ConsumerState<SearchUsers> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(userServiceProvider).searchUsersNyName(_query);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Buscar Usuarios...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>?>(
              future: usersAsync,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeroIcon(
                        HeroIcons.magnifyingGlass,
                        size: 80,
                        style: HeroIconStyle.outline,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No se encontraron usuarios",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Intenta con otro nombre o revisa tu conexión a internet.",
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }
                final users = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: users.length,
                  itemBuilder: (context, index) =>
                      userFoundCard(users[index], index),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Container userFoundCard(User user, int index) {
    final requestSendedFuture = ref
        .read(userServiceProvider)
        .requestPending(user.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.username,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            FutureBuilder<bool>(
              future: requestSendedFuture,
              builder: (context, snapshot) {
                bool? data = snapshot.data;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Mientras carga
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (data == true) {
                  return Text(
                    'Solicitud Pendiente',
                    style: TextStyle(fontSize: 11, color: Colors.green),
                  );
                } else {
                  return SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        ref
                            .read(userServiceProvider)
                            .sendFriendRequest(user.id);

                        setState(() {
                          ref.read(userServiceProvider).requestPending(user.id);
                        });

                        //ref.read(userServiceProvider).acceptFriendRequest("ayTYLNrD9IXq1cAznO6M");
                      },
                      child: Text(
                        "Enviar Solicitud",
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
