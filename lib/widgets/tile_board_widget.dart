import 'dart:math';
import 'package:bee_2048/widgets/animated_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constants_2048.dart';
import '../providers/board_provider.dart';

class TileBoardWidget extends ConsumerWidget {
  const TileBoardWidget(
      {super.key, required this.moveAnimation, required this.scaleAnimation});

  final CurvedAnimation moveAnimation;
  final CurvedAnimation scaleAnimation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(boardManagerProvider);

    //Decides the maximum size the Board can be based on the shortest size of the screen.
    final size = max(
        minSizeScreen,
        min((MediaQuery.of(context).size.shortestSide * 0.90).floorToDouble(),
            maxSizeScreen));

    //Decide the size of the tile based on the size of the board minus the space between each tile.
    final sizePerTile = (size / 4).floorToDouble();
    final tileSize = sizePerTile - tileSpacing - (tileSpacing / 4);
    final boardSize = sizePerTile * 4;

    return SizedBox(
      width: boardSize,
      height: boardSize,
      child: Stack(
        children: [
          ...List.generate(board.tiles.length, (i) {
            var tile = board.tiles[i];
            // Position the tile in the stack based on the index
            return AnimatedTile(
              key: ValueKey(tile.id),
              moveAnimation: moveAnimation,
              scaleAnimation: scaleAnimation,
              tile: tile,
              size: tileSize,
              child: Container(
                width: tileSize,
                height: tileSize,
                decoration: BoxDecoration(
                  color: tileColors[tile.value],
                  borderRadius: BorderRadius.circular(paddingDft / 2),
                ),
                child: Center(
                  child: Text(
                    '${tile.value}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: tile.value < 8 ? textColor : textColorWhite,
                    ),
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
