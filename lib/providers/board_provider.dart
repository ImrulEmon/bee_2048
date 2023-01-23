import 'dart:math';

import 'package:bee_2048/constants/constants_2048.dart';
import 'package:bee_2048/models/board_model.dart';
import 'package:bee_2048/models/tile_model.dart';
import 'package:bee_2048/providers/next_direction_provider.dart';
import 'package:bee_2048/providers/round_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:uuid/uuid.dart';

class BoardManagerStateNotifier extends StateNotifier<Board> {
  // We will use this list to retrieve the right index when user swipes up/down
  // which will allow us to reuse most of the logic.
  final verticalOrder = [12, 8, 4, 0, 13, 9, 5, 1, 14, 10, 6, 2, 15, 11, 7, 3];

  final StateNotifierProviderRef ref;
  BoardManagerStateNotifier(this.ref) : super(Board.newGame(0, [])) {
    newGame();
  }

  // Create New Game State
  Board _newGame() {
    return Board.newGame(state.best + state.score, [random([])]);
  }

  // Start new game
  void newGame() {
    state = _newGame();
  }

  // check whether the indexes are in the same row or column in the board
  bool _inRange(index, nextIndex) {
    return index < 4 && nextIndex < 4 ||
        index >= 4 && index < 8 && nextIndex >= 4 && nextIndex < 8 ||
        index >= 8 && index < 12 && nextIndex >= 8 && nextIndex < 12 ||
        index >= 12 && nextIndex >= 12;
  }

  Tile _calculate(Tile tile, List<Tile> tiles, direction) {
    bool asc =
        direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert =
        direction == SwipeDirection.up || direction == SwipeDirection.down;
    // get first index from the left in the row
    // left swipe -> 0,4,8,12
    // depending which row in the column in the board we need
    int index = vert ? verticalOrder[tile.index] : tile.index;
    int nextIndex = ((index + 1) / 4).ceil() * 4 - (asc ? 4 : 1);

    // if the list of the new tiles to be rendered is not empty get the last tile
    // and if that tile is in the same row as the current tile set the next index for th ecurrent tile to be after the last tile
    if (tiles.isNotEmpty) {
      var last = tiles.last;
      var lastIndex = last.nextIndex ?? last.index;
      lastIndex = vert ? verticalOrder[lastIndex] : lastIndex;
      if (_inRange(index, lastIndex)) {
        // If the order is ascending set the tile after the last processed tile
        // If the order is descending set the tile before the last processed tile
        nextIndex = lastIndex + (asc ? 1 : -1);
      }
    }
    // Return immutable copy of the current tile with the new index
    // which can either ne the top left index in the row or the last tile nextIndex/index+1
    return tile.copyWith(
        nextIndex: vert ? verticalOrder.indexOf(nextIndex) : nextIndex);
  }

  // Move the tile in direction
  bool move(SwipeDirection direction) {
    // Sort the list of tiles by index
    bool asc =
        direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert =
        direction == SwipeDirection.up || direction == SwipeDirection.down;
    // Sort the list of tiles by index
    // if user swipes vertically use thr verticlalOrder list to retrieve ti the up/down index
    state.tiles.sort(((a, b) =>
        (asc ? 1 : -1) *
        (vert
            ? verticalOrder[a.index].compareTo(verticalOrder[b.index])
            : a.index.compareTo(b.index))));
    List<Tile> tiles = [];

    for (int i = 0, l = state.tiles.length; i < l; i++) {
      var tile = state.tiles[i];

      // Calculate nextIndex for current tile
      tile = _calculate(tile, tiles, direction);
      tiles.add(tile);

      if (i + 1 < l) {
        var next = state.tiles[i + 1];
        // Assign current tile next index or index to the next tile if its allowed to be moved.
        if (tile.value == next.value) {
          // swipe vertically user use verticlalOrder list to get up down index
          var index = vert ? verticalOrder[tile.index] : tile.index,
              nextIndex = vert ? verticalOrder[next.index] : next.index;
          if (_inRange(index, nextIndex)) {
            tiles.add(next.copyWith(nextIndex: tile.nextIndex));
            // Skip next iteration if next tile was already assigned nextIndex
            i += 1;
            continue;
          }
        }
      }
    }
    // Assign immutable copy of the new board state and trigger rebuild.
    state = state.copyWith(
      tiles: tiles,
      undo: state,
    );
    return true;
  }

  // Generate tiles at randim place on board
  Tile random(List<int> indexes) {
    var i = 0;
    var rng = Random();
    do {
      i = rng.nextInt(numberOfTiles);
    } while (indexes.contains(i));

    return Tile(const Uuid().v4(), 2, i);
    // Tile(id,value,index)
  }

  // Merge tiles
  void merge() {
    List<Tile> tiles = [];
    var tilesMoved = false;
    List<int> indexes = [];
    var score = state.score;

    for (int i = 0, l = state.tiles.length; i < l; i++) {
      var tile = state.tiles[i];

      var value = tile.value, merged = false;

      if (i + 1 < l) {
        //sum the number of the two tiles with same index and mark the tile as merged and skip the next iteration.
        var next = state.tiles[i + 1];
        if (tile.nextIndex == next.nextIndex ||
            tile.index == next.nextIndex && tile.nextIndex == null) {
          value = tile.value + next.value;
          merged = true;
          score += tile.value;
          i += 1;
        }
      }

      if (merged || tile.nextIndex != null && tile.index != tile.nextIndex) {
        tilesMoved = true;
      }

      tiles.add(tile.copyWith(
          index: tile.nextIndex ?? tile.index,
          nextIndex: null,
          value: value,
          merged: merged));
      indexes.add(tiles.last.index);
    }

    //If tiles got moved then generate a new tile at random position of the available positions on the board.
    if (tilesMoved) {
      tiles.add(random(indexes));
    }
    state = state.copyWith(score: score, tiles: tiles);
  }

// End round,win or lose the game
  void _endRound() {
    var gameOver = true, gameWon = false;
    List<Tile> tiles = [];

    // If there is no more empty place on the board
    if (state.tiles.length == 16) {
      state.tiles.sort(((a, b) => a.index.compareTo(b.index)));

      for (int i = 0, l = state.tiles.length; i < l; i++) {
        var tile = state.tiles[i];

        // if there is a tile with 2048 then the game is won.
        if (tile.value == winningScore) {
          gameWon = true;
        }
        var x = (i - (((i + 1) / 4).ceil() * 4 - 4));

        if (x > 0 && i - 1 >= 0) {
          // if tile can be marged game is not lost
          //If tile can be merged with left tile then game is not lost.
          var left = state.tiles[i - 1];
          if (tile.value == left.value) {
            gameOver = false;
          }
        }

        if (x < 3 && i + 1 < l) {
          //If tile can be merged with right tile then game is not lost.
          var right = state.tiles[i + 1];
          if (tile.value == right.value) {
            gameOver = false;
          }
        }

        if (i - 4 >= 0) {
          //If tile can be merged with above tile then game is not lost.
          var top = state.tiles[i - 4];
          if (tile.value == top.value) {
            gameOver = false;
          }
        }

        if (i + 4 < 1) {
          //If tile can be merged with the bellow tile then game is not lost.
          var bottom = state.tiles[i + 4];
          if (tile.value == bottom.value) {
            gameOver = false;
          }
        }
        // Set the tile merged: false
        tiles.add(tile.copyWith(merged: false));
      }
    } else {
      // still empty box game not over
      gameOver = false;
      for (var tile in state.tiles) {
        // if tile with 2048 then game is won
        // have to change here to play unlimited time
        if (tile.value == winningScore) {
          gameWon = true;
        }
        // Set the tile merged :false
        tiles.add(tile.copyWith(merged: false));
      }
    }
    state = state.copyWith(tiles: tiles, won: gameWon, over: gameOver);
  }

  //Mark the merged as false after the merge animation is complete.
  bool endRound() {
    //End round.
    _endRound();
    ref.read(roundManagerProvider.notifier).end();

    //If player moved too fast before the current animation/transition finished, start the move for the next direction
    var nextDirection = ref.read(nextDirectionManagerProvider);
    if (nextDirection != null) {
      move(nextDirection);
      ref.read(nextDirectionManagerProvider.notifier).clear();
      return true;
    }
    return false;
  }

  // undo one round
  void undo() {
    if (state.undo != null) {
      state = state.copyWith(
        score: state.undo!.score,
        best: state.undo!.best,
        tiles: state.undo!.tiles,
      );
    }
  }
}

final boardManagerProvider =
    StateNotifierProvider<BoardManagerStateNotifier, Board>((ref) {
  return BoardManagerStateNotifier(ref);
});
