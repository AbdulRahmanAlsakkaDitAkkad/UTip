import 'package:flutter/material.dart';

class PersonCounter extends StatelessWidget {
  const PersonCounter({
    super.key,
    required this.theme,
    required int personCount,
    required this.onIcrement,
    required this.onDecrement,
  }) : _personCount = personCount;
  final VoidCallback onIcrement;
  final VoidCallback onDecrement;

  final ThemeData theme;
  final int _personCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Split', style: theme.textTheme.titleMedium),
        Row(
          children: [
            IconButton(
              color: theme.colorScheme.primary,
              onPressed: onDecrement,
              icon: const Icon(Icons.remove),
            ),
            Text('$_personCount', style: theme.textTheme.titleMedium),
            IconButton(
              color: theme.colorScheme.primary,
              onPressed: onIcrement,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
