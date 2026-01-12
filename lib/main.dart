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
              Align(
                alignment: Alignment.center,
                child: IconButton(
                    onPressed: showGlobalSettings,
                    icon: const Icon(Icons.settings)),
              ),
              if (globalSettingsVisible)
                const Align(
                  alignment: Alignment.center,
                  child: GlobalSettings(),
                )
            ],
          ),
        ),
      );
    });
  }
}
