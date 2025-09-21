import 'package:divipay/domain/Group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

import 'package:go_router/go_router.dart';

class GroupCard extends StatelessWidget {
  final Group group;

  const GroupCard({Key? key, required this.group}) : super(key: key);

LinearGradient generateGradientFromKey(String key) {
  int hash = key.hashCode;
  final random = Random(hash);

  // Base azul (DiviPay)
  const baseColor = Color(0xFF0a66c2);

  // Generar dos tonos azules distintos a partir de la base
  HSLColor hslBase = HSLColor.fromColor(baseColor);

  // Pequeña variación de la luminosidad y saturación (para no salir de la gama)
  HSLColor hsl1 = hslBase.withLightness(
    (hslBase.lightness + (random.nextDouble() * 0.2 - 0.1)).clamp(0.3, 0.8),
  );
  HSLColor hsl2 = hslBase.withSaturation(
    (hslBase.saturation + (random.nextDouble() * 0.2 - 0.1)).clamp(0.4, 1.0),
  );

  Color color1 = hsl1.toColor();
  Color color2 = hsl2.toColor();

  return LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [color1, color2],
  );
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push("/detail",extra: group);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 12,
              offset: Offset(2, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 65,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(group.description, style: TextStyle(fontSize: 14)),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${group.balance}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Icon(CupertinoIcons.arrow_right, size: 22,),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}