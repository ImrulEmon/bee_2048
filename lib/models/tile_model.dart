// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bee_2048/constants/constants_2048.dart';

class Tile {
  final String id;
  final int value;
  final int index;
  final int? nextIndex;
  final bool merged;

  Tile(
    this.id,
    this.value,
    this.index, {
    this.nextIndex,
    this.merged = false,
  });

  // Calculate the current top position based on the current index
  double getTop(double size) {
    var i = ((index + 1) / 4).ceil();
    return ((i - 1) * size) + (tileSpacing * i);
  }

  // Calculate the current left position  based on the current index
  double getLeft(double size) {
    var i = (index - (((index + 1) / 4).ceil() * 4 - 4));
    return (i * size) + (tileSpacing * (i + 1));
  }

  //Calculate the next top position based on the next index
  double? getNextTop(double size) {
    if (nextIndex == null) return null;
    var i = ((nextIndex! + 1) / 4).ceil();
    return ((i - 1) * size) + (tileSpacing * i);
  }

  //Calculate the next top position based on the next index
  double? getNextLeft(double size) {
    if (nextIndex == null) return null;
    var i = (nextIndex! - (((nextIndex! + 1) / 4).ceil() * 4 - 4));
    return (i * size) + (12.0 * (i + 1));
  }

  Tile copyWith({
    String? id,
    int? value,
    int? index,
    int? nextIndex,
    bool? merged,
  }) {
    return Tile(
      id ?? this.id,
      value ?? this.value,
      index ?? this.index,
      nextIndex: nextIndex ?? this.nextIndex,
      merged: merged ?? this.merged,
    );
  }
}


// id = unique id used as valueKey for the TileWidget/small box
// value = The number on the tile
// index = The index of the tile on the board from which the position of the tile will be calculated
// nextIndex = The next index of the tile on the board
// merged = Whether the tile was merged with another tile
