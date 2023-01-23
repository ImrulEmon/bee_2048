// Homepage or Main View or GamePage or Game view

import 'package:bee_2048/providers/board_provider.dart';
import 'package:bee_2048/widgets/button_widget.dart';
import 'package:bee_2048/widgets/empty_board_widget.dart';
import 'package:bee_2048/widgets/score_board_widget.dart';
import 'package:bee_2048/widgets/tile_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import '../constants/constants_2048.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // the move animation controller
  late final AnimationController _moveController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ref.read(boardManagerProvider.notifier).merge();
        _scaleController.forward(from: 0.0);
      }
    });

  late final CurvedAnimation _moveAnimation = CurvedAnimation(
    parent: _moveController,
    curve: Curves.easeInOut,
  );

  // merged pop up
  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (ref.read(boardManagerProvider.notifier).endRound()) {
          _moveController.forward(from: 0.0);
        }
      }
    });

  late final CurvedAnimation _scaleAnimation = CurvedAnimation(
    parent: _scaleController,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    //Add an Observer for the Lifecycles of the App
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      onSwipe: (direction, offset) {
        //Move the tiles on Swipe on Android and iOS
        if (ref.read(boardManagerProvider.notifier).move(direction)) {
          _moveController.forward(from: 0.0);
        }
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
                      const SizedBox(height: paddingDft * 2),
                      Row(
                        children: [
                          //Undo button
                          ButtonWidget(
                            icon: Icons.undo,
                            onPressed: () {
                              ref.read(boardManagerProvider.notifier).undo();
                            },
                          ),
                          const SizedBox(width: paddingDft),
                          //New Game button
                          ButtonWidget(
                            icon: Icons.refresh,
                            onPressed: () {
                              ref.read(boardManagerProvider.notifier).newGame();
                            },
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: paddingDft * 2),
            //TODO: Add the Empty Board Widget-have to put it in a Stack
            Stack(
              children: [
                const EmptyBoardWidget(),
                //  TODO : add the tilr Board Widget
                TileBoardWidget(
                  moveAnimation: _moveAnimation,
                  scaleAnimation: _scaleAnimation,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // dispose animations
    _moveAnimation.dispose();
    _scaleAnimation.dispose();
    _moveController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
}
