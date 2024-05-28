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

class _SettingsWidgetState extends State<SettingsWidget>  with SingleTickerProviderStateMixin{
  var showBackground = false;

  void toggleBackgroundSelection() {
    if(showBackground) {
      _animationController.reverse();
      Future.delayed(Duration(milliseconds: 300), (){
        setState(() {
          showBackground = !showBackground;
        });
      });
    } else {
      setState(() {
      showBackground = !showBackground;
      _animationController.forward();
    });
    }

  }
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build (BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 35, top: 10),
      child: 
      showBackground 
      ? 
        AnimatedBuilder(
          animation: _animationController,
          child: BackgroundWidget(toggleBackgroundSelection: toggleBackgroundSelection, player: widget.player),
          builder: (context, child) => 
            SlideTransition(
              position: 
              Tween(
                begin: const Offset(1, 0), 
                end: const Offset(0, 0)
              ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)), 
          child: child,)
          )
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
          for (String button in monoBackgrounds)
            SizedBox(
              height: 50,
              width: 50,
              child: IconButton(onPressed: () => player.changeBackground(button), icon: Image.asset(getImage(button)),),
            )  
          ]
      ),
      Row(
        children: [
          for (String button in dualBackgrounds)
            SizedBox(
              height: 50,
              width: 50,
              child: IconButton(onPressed: () => player.changeBackground(button), icon: Image.asset(getImage(button)),),
            )  
          ]
      ),
      Row(
        children: [
          for (String button in trioBackgrounds)
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
