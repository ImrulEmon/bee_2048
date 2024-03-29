// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// It contains all the Score,Score widget widgets and button
import 'package:bee_2048/providers/board_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constants_2048.dart';

class ScoreBoardWidget extends ConsumerWidget {
  const ScoreBoardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Score
    final score = ref.watch(
      boardManagerProvider.select((board) => board.score),
    );
    // Best Score
    final best = ref.watch(
      boardManagerProvider.select((board) => board.best),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // TODO : connect the state notifier with the score widget
        ScoreWidget(label: 'Score', score: '$score'),
        const SizedBox(
          width: paddingDft / 2,
        ),
        // TODO : connect the state notifier with the best score widget
        ScoreWidget(
          label: 'Best Score',
          score: '$best',
          padding: const EdgeInsets.symmetric(
            horizontal: paddingDft / 2,
            vertical: paddingDft / 2,
          ),
        )
      ],
    );
  }
}

class ScoreWidget extends StatelessWidget {
  final String label;
  final String score;
  final EdgeInsets? padding;

  const ScoreWidget({
    Key? key,
    required this.label,
    required this.score,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
              horizontal: paddingDft, vertical: paddingDft / 2),
      decoration: BoxDecoration(
          color: scoreColor,
          borderRadius: BorderRadius.circular(paddingDft / 2)),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(fontSize: 18.0, color: color2),
          ),
          Text(score,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              )),
        ],
      ),
    );
  }
}
