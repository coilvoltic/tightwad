import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:tightwad/src/dev/tightwad.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/utils/utils.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDaAMCOCv6GK56W3r3hLvAA4ez4N-6PrNY',
      appId: '1:738466289587:web:3b769cb181f5b2a4bd5dc6',
      messagingSenderId: '738466289587',
      projectId: 'tightwad-80f9e',
    ),
  );
  await Database.init();
  runApp(const Tightwad());
}

class Tightwad extends StatelessWidget {
  const Tightwad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OptionsNotifier>(
          create: (_) => OptionsNotifier(),
        ),
        ChangeNotifierProvider<GameHandlerNotifier>(
          create: (_) => GameHandlerNotifier(),
        ),
        ChangeNotifierProvider<EntityNotifier>(
          create: (_) => EntityNotifier(),
        ),
        ChangeNotifierProvider<MultiPlayerNotifier>(
          create: (_) => MultiPlayerNotifier(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: ThemeColors.background.getLightColor,
          ),
        ),
        title: 'Tightwad!',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SafeArea(
        child: Center(
          child: GlowText(
            'tightwad!',
            blurRadius: Utils.shouldGlow() ? 2.5 : 0.0,
            glowColor: Utils.shouldGlow()
                  ? Utils.getPassedColorFromTheme()
                  : Colors.transparent,
            style: TextStyle(
              fontFamily: 'Parisienne',
              decoration: TextDecoration.none,
              fontSize: 80.0,
              fontWeight: FontWeight.bold,
              color: Utils.getPassedColorFromTheme(),
            ),
          ),
        ),
      ),
      nextScreen: const TightWadHome(),
      backgroundColor: Utils.getBackgroundColorFromTheme(),
      animationDuration: const Duration(milliseconds: 2000),
      splashIconSize: 250,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
