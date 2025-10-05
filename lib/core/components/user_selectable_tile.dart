import 'package:flutter/material.dart';
import 'package:divipay/domain/User.dart';

class UserSelectableTile extends StatelessWidget {
  final User user;
  final bool isSelected;
  final VoidCallback onTap;

  const UserSelectableTile({
    Key? key,
    required this.user,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(" ");
    if (parts.isEmpty) return "";
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar con iniciales
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(0.15),
              child: Text(
                _getInitials(user.fullName),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Nombre completo
            Expanded(
              child: Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Check de selección
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? color : Colors.transparent,
              ),
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.check,
                size: 16,
                color: isSelected ? Colors.white : Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }
}