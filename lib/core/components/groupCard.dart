import 'package:divipay/domain/Group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';

class GroupCard extends StatelessWidget {
  final Group group;

  const GroupCard({Key? key, required this.group}) : super(key: key);

  // Genera un gradient a partir de la key del grupo
  LinearGradient generateGradientFromKey(String key) {
    int hash = key.hashCode;
    final random = Random(hash);

    const baseColor = Color(0xFF0a66c2); // Azul DiviPay
    HSLColor hslBase = HSLColor.fromColor(baseColor);

    HSLColor hsl1 = hslBase.withLightness(
      (hslBase.lightness + (random.nextDouble() * 0.2 - 0.1)).clamp(0.3, 0.8),
    );
    HSLColor hsl2 = hslBase.withSaturation(
      (hslBase.saturation + (random.nextDouble() * 0.2 - 0.1)).clamp(0.4, 1.0),
    );

    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [hsl1.toColor(), hsl2.toColor()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push("/detail", extra: group);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 0.3,color: Colors.grey),
          boxShadow: [

          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con gradient
            Container(
              height: 65,
              decoration: BoxDecoration(
                gradient: generateGradientFromKey(group.name),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
            // Contenido de la tarjeta
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    group.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${group.balance}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.arrow_right,
                        size: 22,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
