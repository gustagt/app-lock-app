import 'package:flutter/material.dart';

class AddAppButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddAppButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add_rounded, size: 20),
      label: const Text('Adicionar app'),
    );
  }
}
