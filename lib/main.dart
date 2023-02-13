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
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/utils/utils.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
            backgroundColor: Utils.getBackgroundColorFromTheme(),
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
            'Tw',
            blurRadius: Utils.shouldGlow() ? Utils.GLOWING_VALUE : 0.0,
            glowColor: Utils.shouldGlow()
                  ? Utils.getPassedColorFromTheme()
                  : Colors.transparent,
            style: TextStyle(
              fontFamily: 'FreestyleScript',
              decoration: TextDecoration.none,
              fontSize: 130.0,
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
