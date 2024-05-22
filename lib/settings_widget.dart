import 'package:the_lifecounter/utlis.dart';
import 'package:the_lifecounter/player.dart';
import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({
    super.key,
    required this.setButtons,
    required this.selectedButtons,
    required this.player,
    });
  
  final Function setButtons;
  final List selectedButtons;
  final Player player;

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
    var showBackground = false;

    void toggleBackgroundSelection() {
    setState(() {
      showBackground = !showBackground;
    });
  }


  @override
  Widget build (BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 35, top: 10),
      child: 
      showBackground 
      ? BackgroundWidget(toggleBackgroundSelection: toggleBackgroundSelection, player: widget.player)
      : ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: toggleBackgroundSelection, child: Text("Select background")),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(var button in allButtons)
                CheckboxListTile(title: Text(getButtonText(button)),value: widget.selectedButtons.contains(button), onChanged:  (_) => widget.setButtons(button))
            ],
          ),
        ],
      ),
    );
  }
}

class BackgroundWidget extends StatelessWidget {
  BackgroundWidget({
    super.key,
    required this.toggleBackgroundSelection,
    required this.player,
    });
  
  final Function toggleBackgroundSelection;
  final Player player;

  @override
  Widget build (BuildContext context) {
  return Column(
    children: [
      ElevatedButton(onPressed: () => toggleBackgroundSelection(), child: Text("Close")),
      Row(
        children: [
          for (String button in allBackgrounds)
            SizedBox(
              height: 50,
              width: 50,
              child: IconButton(onPressed: () => player.changeBackground(button), icon: Image.asset(getImage(button)),),
            )  
          ]
      ),
    ],
  );
  }
}
