import 'package:flutter/material.dart';
import 'package:the_lifecounter/components/client_page.dart';
import 'package:the_lifecounter/main.dart';

class ModeMenu extends StatelessWidget {
  const ModeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose mode',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _MenuButton(
                  label: 'Local game',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MyHomePage()),
                  ),
                ),
                const SizedBox(height: 14),
                _MenuButton(
                  label: 'Host a game',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const MyHomePage(
                        showSettingsInitially: true,
                        autoStartHost: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _MenuButton(
                  label: 'Connect to a game',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ClientPage()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.white12,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
