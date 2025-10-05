import 'package:flutter/material.dart';

class Debt extends StatelessWidget {
  const Debt({super.key,required this.cobrador,required this.monto, required this.deudor});

  final String deudor;
  final String cobrador;
  final double monto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "$deudor le debe a $cobrador",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(width: 8),
        Text(
          "\$${monto.toStringAsFixed(2)}",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
