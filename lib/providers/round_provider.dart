import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
************* I have to review to code again to undertand clearly*********
A Notifier TRACK WHEN A ROUND STARTS and ENDS, in order to prevent the next round starts before the current ends
prevent's animation issues when user tries to move tiles too soon.
*/
class RoundManagerStateNotifier extends StateNotifier<bool> {
  RoundManagerStateNotifier() : super(true);

  void end() {
    state = true;
  }

  void begin() {
    state = false;
  }
}

final roundManagerProvider =
    StateNotifierProvider<RoundManagerStateNotifier, bool>((ref) {
  return RoundManagerStateNotifier();
});
