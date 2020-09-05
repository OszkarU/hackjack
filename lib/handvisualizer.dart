import 'package:flutter/material.dart';
import 'package:hackjack_start/frontcard.dart';
import 'package:hackjack_start/hand.dart';

class HandVisualizer extends StatelessWidget {
  Hand hand;
  HandVisualizer(this.hand);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${hand.sum}' +
            ((!hand.hard) ? '(${hand.smallSum.toString()})' : '')),
        SizedBox(
          height: 120,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return FrontCard(hand.cards[index]);
              },
              separatorBuilder: (_, __) => SizedBox(
                    width: 10,
                  ),
              itemCount: hand.length),
        )
      ],
    );
  }
}
