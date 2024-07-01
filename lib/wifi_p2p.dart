import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'The Lifecounter',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: WifiP2P(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
}

class WifiP2P extends StatefulWidget {

  @override
  State<WifiP2P> createState() => _WifiP2PState();
}

class _WifiP2PState extends State<WifiP2P> with WidgetsBindingObserver {
  final _flutterP2pConnectionPlugin = FlutterP2pConnection();
  List<DiscoveredPeers> peers = [];
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;
  WifiP2PInfo? wifiP2PInfo;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flutterP2pConnectionPlugin.unregister();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _flutterP2pConnectionPlugin.unregister();
    } else if (state == AppLifecycleState.resumed) {
      _flutterP2pConnectionPlugin.register();
    }
  }

  void _init() async {
    await _flutterP2pConnectionPlugin.initialize();
    await _flutterP2pConnectionPlugin.register();
    _streamWifiInfo = _flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
      // Handle changes in connection
    });
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      // Handle discovered peers
      setState(() {
      peers = event;
    });
    });
  }

  void discover() {
    _flutterP2pConnectionPlugin.discover();
  }

  void stopDiscovery() {
    _flutterP2pConnectionPlugin.stopDiscovery();
  }
    void connect() async {
    await _flutterP2pConnectionPlugin.connect(peers[0].deviceAddress);
  }

  // create a socket
Future startSocket() async {
  if (wifiP2PInfo != null) {
    await _flutterP2pConnectionPlugin.startSocket(
      groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress!,
      // downloadPath is the directory where received file will be stored
      downloadPath: "/storage/emulated/0/Download/",
      // the max number of downloads at a time. Default is 2.
      maxConcurrentDownloads: 2,
      // delete incomplete transfered file
      deleteOnError: true,
      // handle connections to socket
      onConnect: (name, address) {
        print("$name connected to socket with address: $address");
      },
      transferUpdate: (transfer) {
        print(
            "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
      },
      // handle string transfer from server
      receiveString: (req) async {
        print(req);
      },
    );
  }
}


  @override
  Widget build(BuildContext context) {
    print(peers);
    
    return Scaffold(
      body: SafeArea(child: 
        Column(
          children: [
            Text("Moi :3"),
            ElevatedButton(onPressed: discover, child: Text("Discove")),
            for (var peer in peers)
              Text("${peer.deviceName}")
          ],
        )
      )
    );
  } 
}
