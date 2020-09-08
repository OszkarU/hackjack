import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackjack_start/hand.dart';
import 'package:hackjack_start/handvisualizer.dart';
import 'package:provider/provider.dart';

void main() {
  GetIt.I.registerLazySingleton(() => Random());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(
        headline2: GoogleFonts.roboto(fontSize: 22, color: Colors.white),
        bodyText2: GoogleFonts.roboto(fontSize: 15, color: Colors.white),
      )),
      home: Game(),
    );
  }
}

enum GameState { PLAY, PLAYER_WON, DEALER_WON, EQUAL }

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: PlayerHand()),
        ChangeNotifierProvider.value(value: DealerHand()),
        ProxyProvider2<PlayerHand, DealerHand, GameState>(
            update: (BuildContext context, ph, dh, _) {
          if (ph.burnt) {
            return GameState.DEALER_WON;
          } else if (!ph.done || !dh.done) {
            return GameState.PLAY;
          } else if (dh.burnt && !ph.burnt) {
            return GameState.PLAYER_WON;
          } else if (ph.blackjack && dh.blackjack) {
            return GameState.EQUAL;
          } else if (ph.blackjack && !dh.blackjack) {
            return GameState.PLAYER_WON;
          } else if (!ph.blackjack && dh.blackjack) {
            return GameState.DEALER_WON;
          } else if ((21 - ph.sum) < (21 - dh.sum)) {
            return GameState.PLAYER_WON;
          } else if ((21 - ph.sum) == (21 - dh.sum)) {
            return GameState.EQUAL;
          } else {
            return GameState.DEALER_WON;
          }
        })
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.green,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Dealer hand'),
                  Consumer<DealerHand>(
                    builder: (context, hand, child) => HandVisualizer(hand),
                  )
                ],
              ),
              Column(
                children: [
                  Text('Player hand'),
                  Consumer<PlayerHand>(
                    builder: (context, hand, child) => HandVisualizer(hand),
                  )
                ],
              ),
              Consumer<GameState>(builder: (context, gs, child) {
                if (gs == GameState.PLAYER_WON) {
                  return Text('Player won');
                } else if (gs == GameState.DEALER_WON) {
                  return Text('Dealer won');
                } else if (gs == GameState.EQUAL) {
                  return Text('Draw');
                } else
                  return Container();
              }),
              Consumer3<GameState, PlayerHand, DealerHand>(
                builder: (context, gs, ph, dh, _) {
                  var buttons = <Widget>[];
                  if (gs == GameState.PLAY) {
                    buttons.addAll([
                      RaisedButton.icon(
                          onPressed: ph.length == 2
                              ? () async {
                                  ph.draw();
                                  await Future.delayed(
                                      Duration(milliseconds: 500));
                                  dh.play();
                                }
                              : null,
                          icon: Icon(Icons.arrow_upward),
                          label: Text('Double'.toUpperCase())),
                      RaisedButton.icon(
                          onPressed: () {
                            ph.draw();
                          },
                          icon: Icon(Icons.play_circle_outline),
                          label: Text('Hit'.toUpperCase())),
                      RaisedButton.icon(
                          onPressed: () {
                            ph.done = true;
                            dh.play();
                          },
                          icon: Icon(Icons.stop),
                          label: Text('Stand'.toUpperCase()))
                    ]);
                  } else {
                    buttons.add(RaisedButton.icon(
                        onPressed: () => setState(() {}),
                        icon: Icon(Icons.refresh),
                        label: Text('Restart')));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: buttons
                          .map((e) => SizedBox(
                                child: e,
                                width: _width,
                              ))
                          .toList(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
