import 'dart:ui';

const double paddingDft = 16.0;
const double tileSpacing12 = 12.0;
// Screen size
const double maxSizeScreen = 460.0;
const double minSizeScreen = 290.0;

const String newGame = 'New Game';
const String tryAgain = 'Try again';
const String youWin = 'You Win!';
const String gameOver = 'Game Over !';

const int winningScore = 2048;

const backgroundColor = Color(0xfffaf8ef);
const textColor = Color(0xff776e65);
const textColorWhite = Color(0xfff9f6f2);
const boardColor = Color(0xffbbada0);
const emptyTileColor = Color(0xffcdc1b4);
const buttonColor = Color(0xff8f7a66);
const scoreColor = Color(0xffbbada0);
const overlayColor = Color.fromRGBO(238, 228, 218, 0.73);

const color2 = Color(0xffeee4da);
const color4 = Color(0xffeee1c9);
const color8 = Color(0xfff3b27a);
const color16 = Color(0xfff69664);
const color32 = Color(0xfff77c5f);
const color64 = Color(0xfff75f3b);
const color128 = Color(0xffedd073);
const color256 = Color(0xffedcc62);
const color512 = Color(0xffedc950);
const color1024 = Color(0xffedc53f);
const color2048 = Color(0xffedc22e);

// Tile Widget that’s the numbered square that will move, change number and color
const tileColors = {
  2: color2,
  4: color4,
  8: color8,
  16: color16,
  32: color32,
  64: color64,
  128: color128,
  256: color256,
  512: color512,
  1024: color1024,
  2048: color2048,
};
