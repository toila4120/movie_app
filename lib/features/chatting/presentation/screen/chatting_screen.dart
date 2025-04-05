import 'package:flutter/widgets.dart';
import 'package:movie_app/core/core.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  @override
  Widget build(BuildContext context) {
    return const AppContainer(
      resizeToAvoidBottomInset: true,
      child: ScrollConfiguration(
        behavior: DisableGlowBehavior(),
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: DisableGlowBehavior(),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Text('Chatting Screen'),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
