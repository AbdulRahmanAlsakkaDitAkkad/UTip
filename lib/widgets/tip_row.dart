import 'package:flutter/material.dart';

class TipRow extends StatelessWidget {
  const TipRow({
    super.key,
    required this.theme,
    required this.totalT,
    required this.style,
  });

  final ThemeData theme;
  final double totalT;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Tip', style: theme.textTheme.titleMedium),
        Text(
          totalT.toStringAsFixed(2),
          style: style.copyWith(
            color: theme.colorScheme.primary,
            fontSize: theme.textTheme.displaySmall?.fontSize,
          ),
        ),
      ],
    );
  }
}
