import 'package:flutter/material.dart';
import 'package:the_lifecounter/functions/player.dart';
import 'package:the_lifecounter/functions/utlis.dart';

class LifeCounter extends StatelessWidget {
  LifeCounter({
    super.key,
    required this.player,
    required this.onChangeLife,
  });

  final Player player;
  final void Function(int delta) onChangeLife;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isTall = constraints.maxHeight > 117;
      final bool isWide = constraints.maxWidth > 400;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    if(isTall && !isWide)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            height: 40,
                            onPressed: () {
                              onChangeLife(-5);
                            },
                            child: WhiteBorderText(text: "- 5", strokeWidth: 2,),
                            ),
                        ],
                      ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if(isWide)
                          MaterialButton(
                            minWidth: 10,
                            height: 40,
                            onPressed: () {
                              onChangeLife(-5);
                            },
                            child: WhiteBorderText(text: "- 5", strokeWidth: 2),
                        ),
                        SizedBox(width: 20),
                        MaterialButton(
                          height: 60,
                          onPressed: () {
                            onChangeLife(-1);
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
                  : SizedBox(height: 32,),
                  FittedBox(fit: BoxFit.fitHeight, child: WhiteBorderText(text: player.life.toString(), fontSize: 50, height: 0.7,)
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    if(isTall && !isWide)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MaterialButton(
                            height: 40,
                            onPressed: () {
                              onChangeLife(5);
                            },
                            child: WhiteBorderText(text: "+ 5", strokeWidth: 2),
                            ),
                        ],
                      ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MaterialButton(
                          height: 60,
                          onPressed: () {
                            onChangeLife(1);
                          },
                          child: WhiteBorderText(text: "+", fontSize: 50,),
                          ),
                          SizedBox(width: 20),
                        if(isWide)
                            MaterialButton(
                              height: 40,
                              minWidth: 10,
                              onPressed: () {
                                onChangeLife(5);
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
      );
    });
  }
}
