import 'package:flutter/material.dart';

/// Asks the user to confirm a decision before it is applied.
///
/// Returns `true` only when the user confirms.
Future<bool> showConfirmDialog(
    BuildContext context, {
      required String title,
      required String message,
      required String confirmLabel,
      String cancelLabel = 'Cancel',
      bool destructive = false,
    }) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: destructive
                ? const Color(0xFFB3261E)
                : Colors.lightGreen,
          ),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Shows a short feedback message.
void showFeedbackMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}