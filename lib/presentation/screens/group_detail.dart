import 'package:divipay/core/components/app_bar.dart';
import 'package:divipay/domain/Group.dart';
import 'package:divipay/provider/groups_provider.dart';
import 'package:divipay/widgets/group_action_buttons.dart';
import 'package:divipay/widgets/spent_summary.dart';
import 'package:flutter/material.dart';
import 'package:divipay/core/components/bottom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:divipay/widgets/group_info.dart';

class Groupdetail extends ConsumerStatefulWidget {
  const Groupdetail({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<Groupdetail> createState() => _GroupdetailState();
}

class _GroupdetailState extends ConsumerState<Groupdetail> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: StreamBuilder<Group?>(
        stream: ref.read(groupServiceProvider).getById(widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final group = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  GroupInfo(group: group),
                  SizedBox(height: 10),
                  SpentSummary(groupId: group.id),
                  SizedBox(height: 25),
                  GroupActionButtons(group: group),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
