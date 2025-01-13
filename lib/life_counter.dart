import 'package:flutter/material.dart';
import 'package:the_lifecounter/player.dart';
import 'package:the_lifecounter/player_card.dart';
import 'package:the_lifecounter/utlis.dart';

class LifeCounter extends StatefulWidget {
  LifeCounter({
    super.key,
    required this.widget,
    required this.player,
  });

  final PlayerCard widget;
  final Player player;

  @override
  State<LifeCounter> createState() => _LifeCounterState();
}

class _LifeCounterState extends State<LifeCounter> {
  var globalKey = GlobalKey();
  Size? lifeSize;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        newLifeSize();
      });
    });
    super.initState();
  }


  Size getLifeSize(BuildContext context) {
    final box = globalKey.currentContext!.findRenderObject() as RenderBox;
    return box.size;
  }

  void newLifeSize() {
    if (globalKey.currentContext != null) {
      setState(() {
        lifeSize = getLifeSize(globalKey.currentContext!);  
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    newLifeSize();

    return Expanded(
      key: globalKey,
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
                      if(lifeSize != null && lifeSize!.height > 117 && lifeSize!.width < 400)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                              height: 40,
                              onPressed: () {
                                widget.player.changeLife(-5);
                              },
                              child: WhiteBorderText(text: "- 5", strokeWidth: 2,),
                              ),
                          ],
                        ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if(lifeSize != null && lifeSize!.width > 400)
                            MaterialButton(
                              minWidth: 10,
                              height: 40,
                              onPressed: () {
                                widget.player.changeLife(-5);
                              },
                              child: WhiteBorderText(text: "- 5", strokeWidth: 2),
                          ),
                          MaterialButton(
                            height: 60,
                            onPressed: () {
                              widget.player.changeLife(-1);
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
                    widget.player.lifeChange != 0 
                    ? WhiteBorderText(text: "${widget.player.lifeChange}", fontSize: 25) 
                    : SizedBox(height: 32,),
                    FittedBox(fit: BoxFit.fitHeight, child: WhiteBorderText(text: widget.player.lifeAsString(), fontSize: 50, height: 0.7,)
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      if(lifeSize != null && lifeSize!.height > 117 && lifeSize!.width < 400)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MaterialButton(
                              height: 40,
                              onPressed: () {
                                widget.player.changeLife(5);
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
                              widget.player.changeLife(1);
                            },
                            child: WhiteBorderText(text: "+", fontSize: 50,),
                            ),
                          if(lifeSize != null && lifeSize!.width > 400)
                              MaterialButton(
                                height: 40,
                                minWidth: 10,
                                onPressed: () {
                                  widget.player.changeLife(5);
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
