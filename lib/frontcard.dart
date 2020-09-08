import 'package:flutter/material.dart';
import 'package:hackjack_start/hand.dart';

class FrontCard extends StatelessWidget {
  PlayingCard card;
  FrontCard(this.card);
  @override
  Widget getSuit() {
    if (card.suit == Suit.HEART) {
      return Text('♥', style: TextStyle(fontSize: 20, color: Colors.red));
    } else if (card.suit == Suit.DIAMOND) {
      return Text('♦', style: TextStyle(fontSize: 20, color: Colors.red));
    } else if (card.suit == Suit.CLUB) {
      return Text('♣', style: TextStyle(fontSize: 20, color: Colors.black));
    } else if (card.suit == Suit.SPADE) {
      return Text('♠', style: TextStyle(fontSize: 20, color: Colors.black));
    }
  }

  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
          height: 120,
          width: 80,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.type,
                style: TextStyle(color: Colors.black),
              ),
              getSuit(),
              Text(
                card.type,
                style: TextStyle(color: Colors.black),
              )
            ],
          )),
    );
  }
}
