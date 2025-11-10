import 'package:flutter/material.dart';

Future<dynamic> deleteItemDialog(
  BuildContext context,
  String title,
  String subtitle,
  Function deleteFunction,
) {
  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                deleteFunction();
                Navigator.pop(context);
              },
              child: Text(
                'Elimina',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
  );
}
