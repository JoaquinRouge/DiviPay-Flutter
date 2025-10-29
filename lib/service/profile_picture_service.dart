import 'dart:math';

import 'package:flutter/material.dart';

class ProfilePictureService {
  static Widget buildUserInfo(
    String username,
    String email,
    String profileImageUrl,
    double radius,
    double imageFontSize,
    double usernameFontSize,
  ) {
    final color = colorFromName(username);

    return Column(
      children: [
        profileImageUrl.isEmpty
            ? CircleAvatar(
                radius: radius,
                backgroundColor: color.withOpacity(0.9),
                child: Text(
                  username[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: imageFontSize,
                  ),
                ),
              )
            : CircleAvatar(
                radius: radius, // tamaño del círculo
                backgroundImage: NetworkImage(profileImageUrl),
                backgroundColor:
                    Colors.grey[200], // color de fondo mientras carga
              ),
        const SizedBox(height: 4),
        SizedBox(
          child: Text(
            username,
            style: TextStyle(
              fontSize: usernameFontSize,
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

  static Padding smallPicture(String username, String profileImageUrl) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          profileImageUrl.isEmpty
              ? CircleAvatar(
                  radius: 18,
                  backgroundColor: colorFromName(username).withOpacity(0.9),
                  child: Text(
                    username[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(profileImageUrl),
                  backgroundColor:
                      Colors.grey[200],
                ),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            child: Text(
              username,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  static Color colorFromName(String name) {
    final random = Random(name.hashCode);
    final hue = random.nextInt(360);
    return HSLColor.fromAHSL(1, hue.toDouble(), 0.45, 0.55).toColor();
  }
}
