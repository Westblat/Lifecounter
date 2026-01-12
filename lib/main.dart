import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_lifecounter/components/global_settings.dart';
import 'package:the_lifecounter/state/game_state.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  var globalSettingsVisible = false;

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
                child: AnimatedScale(
                  scale: globalSettingsVisible ? 1.0 : 0.9,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: globalSettingsVisible ? 1.0 : 0.0,
                    child: globalSettingsVisible
                        ? const GlobalSettings()
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
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
            ],
          ),
        ),
      );
    });
  }
}
