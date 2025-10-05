import 'package:divipay/core/components/app_bar.dart';
import 'package:divipay/domain/Group.dart';
import 'package:divipay/widgets/group_action_buttons.dart';
import 'package:divipay/widgets/spent_summary.dart';
import 'package:flutter/material.dart';
import 'package:divipay/core/components/bottom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:divipay/widgets/group_info.dart';

class Groupdetail extends ConsumerStatefulWidget {
  const Groupdetail({super.key, required this.group});

  final Group group;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              GroupInfo(group: widget.group,),
              SizedBox(height: 10),
              SpentSummary(groupId:widget.group.id),
              SizedBox(height: 25),
              GroupActionButtons(group: widget.group)
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}