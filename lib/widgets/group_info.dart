import 'package:divipay/domain/Group.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class GroupInfo extends StatelessWidget {
  GroupInfo({super.key, required this.group});

  Group group;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //Modificar nombre y descripcion del grupo
                  },
                  child: HeroIcon(HeroIcons.pencilSquare),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(group.description, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(
              "Fecha de creación: ${group.createdAt}",
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 10),
            Text(
              "Cantidad de integrantes: ${group.members.length}",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
