import 'package:bee_2048/views/game_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  //Allow only portrait mode on Android & iOS
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(const ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bee 2048',
      home: GamePage(),
    ),
  ));
}
