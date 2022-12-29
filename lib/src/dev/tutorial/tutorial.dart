import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/dev/tutorial/components/learning/learning_pages.dart';
import 'package:tightwad/src/dev/tutorial/components/welcome_page.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {

  @override
  Widget build(BuildContext context) {

    return Consumer<EntityNotifier>(
      builder: (context, entityNotifier, _) {
        if (entityNotifier.getTutoPhase == TutorialPhase.welcome)
        {
          return const WelcomePage();
        }
        else
        {
          return const LearningPages();
        }
      }
    );
  }
}