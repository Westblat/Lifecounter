import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_lifecounter/state/game_state.dart';

class GlobalSettings extends ConsumerWidget {
  const GlobalSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameStateProvider.notifier);
    final gameState = ref.watch(gameStateProvider);
    final color = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RoundIconButton(
                  icon: Icons.restart_alt_rounded,
                  label: "Restart",
                  onPressed: controller.restartGame,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RoundIconButton(
                  icon: Icons.add_circle_outline,
                  label: "Add",
                  onPressed: controller.addPlayer,
                ),
                const SizedBox(width: 32),
                _RoundIconButton(
                  icon: Icons.remove_circle_outline,
                  label: "Remove",
                  onPressed: controller.removePlayer,
                ),
              ],
            ),
            const SizedBox(height: 75),
            _CircleButton(
              selected: gameState.layout == "standard",
              child: Text(
                "S",
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: gameState.layout == "standard"
                      ? color.onPrimaryContainer
                      : Colors.white,
                ),
              ),
              onTap: () {
                controller.setLayout("standard");
                controller.setGameMode('standard');
              },
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleIcon(
                  asset: "lib/custom_icons/default_icon.png",
                  selected: gameState.layout == "default",
                  onTap: () {
                    controller.setGameMode('commander');
                    controller.setLayout("default");
                  },
                ),
                const SizedBox(width: 10),
                _CircleIcon(
                  asset: "lib/custom_icons/both_ends_icon.png",
                  selected: gameState.layout == "bothEnds",
                  onTap: () {
                    controller.setGameMode('commander');
                    controller.setLayout("bothEnds");
                  },
                ),
                const SizedBox(width: 10),
                _CircleIcon(
                  asset: "lib/custom_icons/one_end_icon.png",
                  selected: gameState.layout == "oneEnd",
                  onTap: () {
                    controller.setGameMode('commander');
                    controller.setLayout("oneEnd");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white12,
              border: Border.all(color: Colors.white30, width: 2),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 36, color: Colors.white),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.child,
    required this.onTap,
    this.selected = false,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(60),
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? color.primaryContainer : Colors.transparent,
          border: Border.all(color: Colors.white54, width: 3),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({
    required this.asset,
    required this.onTap,
    this.selected = false,
  });

  final String asset;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            color: selected ? Colors.orangeAccent : Colors.white54,
            width: selected ? 3 : 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Image.asset(asset, height: 50, width: 50),
        ),
      ),
    );
  }
}
