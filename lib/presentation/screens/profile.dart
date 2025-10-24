import 'package:divipay/core/components/app_bar.dart';
import 'package:divipay/core/components/bottom_app_bar.dart';
import 'package:divipay/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsIds = ref.read(userServiceProvider).getFriendsIds();

    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder(
        future: friendsIds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final friends = snapshot.data!;
          return Text(friends.first);
        },
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
