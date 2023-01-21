import 'package:bee_2048/widgets/button_widget.dart';
import 'package:bee_2048/widgets/score_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import '../constants/constants.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        //Move the tile with the arrows on the keyboard on Desktop
      },
      child: SwipeDetector(
        onSwipe: (direction, offset) {
          //Move the tiles on Swipe on Android and iOS
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingDft),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Game name
                    const Text(
                      '2048',
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 52.0),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Score board
                        const ScoreBoardWidget(),
                        const SizedBox(height: paddingDft),
                        Row(
                          children: [
                            //Undo button
                            ButtonWidget(
                              icon: Icons.undo,
                              onPressed: () {
                                // TODO : Undo the round
                              },
                            ),
                            const SizedBox(width: paddingDft),
                            //New Game button
                            ButtonWidget(
                              icon: Icons.refresh,
                              onPressed: () {
                                // TODO : Restart the game
                              },
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              //TODO: Add the Empty Board Widget
            ],
          ),
        ),
      ),
    );
  }
}
