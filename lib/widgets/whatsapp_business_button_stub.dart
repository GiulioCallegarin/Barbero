import 'package:flutter/material.dart';

class WhatsAppBusinessButton extends StatelessWidget {
  final String phoneNumber;
  final String message;
  final VoidCallback onSaved;
  final Widget child;

  const WhatsAppBusinessButton({
    super.key,
    required this.phoneNumber,
    required this.message,
    required this.onSaved,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSaved,
      child: child,
    );
  }
}
