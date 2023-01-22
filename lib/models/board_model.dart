// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bee_2048/models/tile_model.dart';

class Board {
  final int score;
  final int best;
  final List<Tile> tiles;
  final bool over;
  final bool won;
  final Board? undo;
  Board(
    this.score,
    this.best,
    this.tiles, {
    this.over = false,
    this.won = false,
    this.undo,
  });
  // Model for new game
  Board.newGame(
    this.best,
    this.tiles,
  )   : score = 0,
        over = false,
        won = false,
        undo = null;

  Board copyWith({
    int? score,
    int? best,
    List<Tile>? tiles,
    bool? over,
    bool? won,
    Board? undo,
  }) {
    return Board(
      score ?? this.score,
      best ?? this.best,
      tiles ?? this.tiles,
      over: over ?? this.over,
      won: won ?? this.won,
      undo: undo ?? this.undo,
    );
  }
}

// score = current score on the board
// best = Best score on the board 
// tiles = List of tiles shown on board
// over = Game over or not
// Board = keeps the previous round info for undo
// won = player won or lost 