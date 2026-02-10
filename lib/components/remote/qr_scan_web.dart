import 'package:flutter/material.dart';

Future<String?> scanQr(BuildContext context) async {
  if (!context.mounted) return null;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('QR scanning is not supported on web.')),
  );
  return null;
}
