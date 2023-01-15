import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:tightwad/src/dev/tightwad.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/database/database.dart';

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
            blurRadius: 5.0,
            style: GoogleFonts.parisienne(
              decoration: TextDecoration.none,
              fontSize: 80.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      nextScreen: const TightWadHome(),
      backgroundColor: ThemeColors.background.getDiamondColor,
      animationDuration: const Duration(milliseconds: 2000),
      splashIconSize: 250,
      splashTransition: SplashTransition.slideTransition,
    );
  }
}
