import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_lifecounter/components/global_settings.dart';
import 'package:the_lifecounter/state/game_state.dart';

import 'components/menu.dart';
import 'components/layouts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Lifecounter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const ModeMenu(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({
    super.key,
    this.showSettingsInitially = false,
    this.autoStartHost = false,
  });

  final bool showSettingsInitially;
  final bool autoStartHost;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late bool globalSettingsVisible = widget.showSettingsInitially;
  bool hostPopupVisible = false;

  void showGlobalSettings() {
    setState(() {
      globalSettingsVisible = !globalSettingsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              switch (gameState.layout) {
                "default" => DefaultLayout(players: gameState.players),
                "bothEnds" => PlayersBothEndLayout(players: gameState.players),
                "oneEnd" => PlayersOneEndLayout(players: gameState.players),
                "standard" => StandardLayout(players: gameState.players),
                String() => throw UnimplementedError(),
              },
              IgnorePointer(
                ignoring: !globalSettingsVisible,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: globalSettingsVisible ? 0.55 : 0.0,
                  child: GestureDetector(
                    onTap: showGlobalSettings,
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: IgnorePointer(
                  ignoring: !globalSettingsVisible,
                  child: AnimatedScale(
                    scale: globalSettingsVisible ? 1.0 : 0.9,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: globalSettingsVisible ? 1.0 : 0.0,
                    child: GlobalSettings(
                      autoStartHost: widget.autoStartHost,
                      onHostPopupChanged: (visible) {
                        setState(() {
                          hostPopupVisible = visible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              ),
              Align(
                alignment: Alignment.center,
                child: IgnorePointer(
                  ignoring: hostPopupVisible,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: hostPopupVisible ? 0.0 : 1.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      height: globalSettingsVisible ? 68 : 52,
                      width: globalSettingsVisible ? 68 : 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: globalSettingsVisible
                            ? Colors.black.withValues(alpha:0.85)
                            : null,
                        boxShadow: [
                          if (globalSettingsVisible)
                            BoxShadow(
                              color: Colors.black.withValues(alpha:0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            )
                        ],
                      ),
                      child: IconButton(
                        onPressed: showGlobalSettings,
                        iconSize: globalSettingsVisible ? 36 : 30,
                        color: globalSettingsVisible ? Colors.white : Colors.black,
                        icon: const Icon(Icons.settings),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
