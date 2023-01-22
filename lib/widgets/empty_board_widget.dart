import 'dart:math';

import 'package:bee_2048/constants/constants_2048.dart';
import 'package:flutter/material.dart';

class EmptyBoardWidget extends StatelessWidget {
  const EmptyBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Maximum size of the board can be based on the shortest size if the screeen
    final size = max(
      minSizeScreen,
      min(
        MediaQuery.of(context).size.shortestSide * .90,
        maxSizeScreen,
      ),
    );
    // Size of the tile based on the size of the board minus the space between each tile
    final sizePerTile = (size / 4).floorToDouble();
    final tileSize = sizePerTile - 12.0 - (12.0 / 4);
    final boardSize = sizePerTile * 4;

    // Board where game will be played
    return Container(
      width: boardSize,
      height: boardSize,
      decoration: BoxDecoration(
        color: boardColor,
        borderRadius: BorderRadius.circular(paddingDft / 2),
      ),
      // Smaller boxes in the board where the numbers will be shown
      child: Stack(
        children: List.generate(16, (index) {
          // render the empty board in 4x4 GridView
          var xAxis = ((index + 1) / 4).ceil();
          var yAxis = xAxis - 1;

          var top = yAxis * (tileSize) + (xAxis * tileSpacing);
          var zAxis = (index - (4 * yAxis));
          var left = zAxis * (tileSize) + ((zAxis + 1) * tileSpacing);

          // these are the smaller boxes/tile/cards
          return Positioned(
            top: top,
            left: left,
            child: Container(
              width: tileSize,
              height: tileSize,
              decoration: BoxDecoration(
                color: emptyTileColor,
                borderRadius: BorderRadius.circular(paddingDft / 2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
