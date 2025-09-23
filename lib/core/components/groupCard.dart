import 'package:divipay/domain/Group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';

class GroupCard extends StatelessWidget {
  final Group group;

  const GroupCard({Key? key, required this.group}) : super(key: key);

  // Genera un gradient único a partir de la key
  LinearGradient generateGradientFromKey(String key) {
    int hash = key.hashCode;
    final random = Random(hash);

    const baseColor = Color(0xFF0a66c2);
    HSLColor hslBase = HSLColor.fromColor(baseColor);

    double hueVariation = (random.nextDouble() * 80 - 40);
    HSLColor hsl1 = hslBase
        .withHue((hslBase.hue + hueVariation) % 360)
        .withLightness(
          (hslBase.lightness + (random.nextDouble() * 0.2 - 0.1))
              .clamp(0.35, 0.75),
        );

    double hueVariation2 = (random.nextDouble() * 80 - 40);
    HSLColor hsl2 = hslBase
        .withHue((hslBase.hue + hueVariation2) % 360)
        .withSaturation(
          (hslBase.saturation + (random.nextDouble() * 0.3 - 0.15))
              .clamp(0.5, 1.0),
        )
        .withLightness(
          (hslBase.lightness + (random.nextDouble() * 0.25 - 0.1))
              .clamp(0.35, 0.8),
        );

    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [hsl1.toColor(), hsl2.toColor()],
    );
  }

  String getInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push("/detail", extra: group),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con gradient
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: generateGradientFromKey(group.name),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                ),
                // Contenido
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        group.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        group.description,
                        maxLines:2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${group.balance}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.arrow_right,
                            size: 22,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 35,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(width: 3, color: Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      getInitials(group.name),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
