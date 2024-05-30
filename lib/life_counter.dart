import 'package:flutter/material.dart';
import 'package:the_lifecounter/player.dart';
import 'package:the_lifecounter/player_card.dart';
import 'package:the_lifecounter/utlis.dart';

class LifeCounter extends StatelessWidget {
  const LifeCounter({
    super.key,
    required this.widget,
    required this.player,
  });

  final PlayerCard widget;
  final Player player;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(                  
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      if(width > 412)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                              height: 40,
                              onPressed: () {
                                player.changeLife(-5);
                              },
                              child: WhiteBorderText(text: "- 5", strokeWidth: 2,),
                              ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if(width < 412 && height > 567)
                            MaterialButton(
                              minWidth: 10,
                              height: 40,
                              onPressed: () {
                                player.changeLife(-5);
                              },
                              child: WhiteBorderText(text: "- 5", strokeWidth: 2),
                          ),
                          MaterialButton(
                            height: 60,
                            onPressed: () {
                              player.changeLife(-1);
                            },
                            child: WhiteBorderText(text: "–", fontSize: 50,),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    player.lifeChange != 0 
                    ? WhiteBorderText(text: "${player.lifeChange}", fontSize: 25) 
                    : SizedBox(height: 36,),
                    FittedBox(fit: BoxFit.fitHeight, child: WhiteBorderText(text: player.lifeAsString(), fontSize: 50, height: 0.7,)
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      if(width > 412)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MaterialButton(
                              height: 40,
                              onPressed: () {
                                player.changeLife(5);
                              },
                              child: WhiteBorderText(text: "+ 5", strokeWidth: 2),
                              ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MaterialButton(
                            height: 60,
                            onPressed: () {
                              player.changeLife(1);
                            },
                            child: WhiteBorderText(text: "+", fontSize: 50,),
                            ),
                            if(width < 412 && height > 567)
                                MaterialButton(
                                  height: 40,
                                  minWidth: 10,
                                  onPressed: () {
                                    player.changeLife(5);
                                  },
                                  child: WhiteBorderText(text: "+ 5", strokeWidth: 2),
                                  ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
