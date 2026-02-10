import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<String?> scanQr(BuildContext context) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(builder: (_) => const _QrScanPage()),
  );
}

class _QrScanPage extends StatefulWidget {
  const _QrScanPage();

  @override
  State<_QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<_QrScanPage> {
  bool _found = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR'),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_found) return;
          final barcodes = capture.barcodes;
          if (barcodes.isEmpty) return;
          final value = barcodes.first.rawValue;
          if (value == null || value.trim().isEmpty) return;
          _found = true;
          Navigator.of(context).pop(value);
        },
      ),
    );
  }
}
