import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OnlineGame extends StatefulWidget {
  var channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8765'),
  );
  var onlineData = null;
  @override
  State<OnlineGame> createState() => _OnlineGameState();
  
}

class _OnlineGameState extends State<OnlineGame> {
  
  @override
  void initState() {
    listenToStream();
    super.initState();
  }

  void listenToStream() {
    print("moi");
    widget.channel.stream.listen(
          (data) {
            print(data);
            setState(() {
              widget.onlineData = data;
            });
          }, onDone: () {
            print(widget.channel);
          }, onError: (error) {
            print(error);
          }
        );
  }
  

  void reconnect() {
    widget.channel.sink.close();
    setState(() {
      widget.channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8765'),
        );
    });
    listenToStream();
  }

  void close() {
    setState(() {
      widget.channel.sink.close();  
    });
  }

  @override
  void dispose() {
    print("dispose");
    widget.channel.sink.close();
    super.dispose();
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
              if(widget.channel.closeCode == null) ElevatedButton(onPressed: () => {widget.channel.sink.add(jsonEncode({"command": "new_player"}))}, child: Text("Send to server")),
              ElevatedButton(onPressed: () => {reconnect()}, child: Text("Reconnect")),
              if(widget.channel.closeCode == null) ElevatedButton(onPressed: () => close(), child: Text("Close connection")),
                Text(widget.onlineData != null ? '${jsonDecode(widget.onlineData)}' : 'no data'),            
          ],
          )
        ),
    );
  }
}