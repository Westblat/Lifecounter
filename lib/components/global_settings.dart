import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_lifecounter/functions/utlis.dart';
import 'package:the_lifecounter/main.dart';

class GlobalSettings extends StatelessWidget {
  const GlobalSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    double height = MediaQuery.of(context).size.height;
    
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: appState.restartGame, icon: Icon(Icons.restart_alt_rounded), iconSize: 50,)
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: appState.addPlayer, icon: Icon(Icons.add_circle_outline), iconSize: 50,),
                SizedBox(width: 40,),
                IconButton(onPressed: appState.removePlayer, icon: Icon(Icons.remove_circle_outline), iconSize: 50,)
              ],
            ),
            SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: const Color.fromARGB(255, 82, 82, 82),
                        width: 4, 
                      )
                    ),
                  child: MaterialButton(
                    onPressed: () {
                      appState.setLayout("standard");
                      appState.setGameMode('standard');
                    }, 
                    height: 50, 
                    minWidth: 50,
                    child: WhiteBorderText(text: "S", fontSize: 40,), 
                    ), 
                  ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: const Color.fromARGB(255, 82, 82, 82),
                      width: 4, 
                    )
                  ),
                  child: IconButton(onPressed: () {
                      appState.setGameMode('commander'); 
                      appState.setLayout("default");
                    }, icon: Image.asset("lib/custom_icons/default_icon.png", height: 50, width: 50,), )
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: const Color.fromARGB(255, 82, 82, 82),
                        width: 4, 
                      )
                    ),
                  child: IconButton(onPressed: () {
                    appState.setGameMode('commander');
                    appState.setLayout("bothEnds");
                  }, icon: Image.asset("lib/custom_icons/both_ends_icon.png", height: 50, width: 50,), )
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: const Color.fromARGB(255, 82, 82, 82),
                        width: 4, 
                      )
                    ),
                  child: IconButton(onPressed: () {
                    appState.setGameMode('commander');
                    appState.setLayout("oneEnd");
                  }, icon: Image.asset("lib/custom_icons/one_end_icon.png", height: 50, width: 50,), )
                  ),
              ],
            ),
          ],
      ),
    );
  }
}
