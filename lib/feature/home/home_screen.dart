import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz/common/widget/button/icon_text_button.dart';
import 'package:quiz/common/widget/button/primary_button.dart';
import 'package:quiz/common/widget/button/secondary_button.dart';
import 'package:quiz/feature/question/question_screen.dart';
import 'package:quiz/feature/topic/topic_screen.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 80,
            ),
            SizedBox(
              width: 120,
              height: 120,
              child: Lottie.asset('assets/bulb.json'),
            ),
            const SizedBox(
              height: 20,
            ),
            const Column(
              children: [
                Text(
                  "Flutter Quiz App",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Learn • Take Quiz • Repeat",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PrimaryButton(
                      text: "PLAY",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QuestionScreen()));
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  SecondaryButton(
                    text: "TOPICS",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TopicScreen()));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconTextButton(
                  onTap: () async {
                    final result = await Share.shareWithResult(
                        'check out my website https://example.com');

                    if (result.status == ShareResultStatus.success) {
                      print('Thank you for sharing my website!');
                    }
                  },
                  text: "Share",
                  icon: Icons.share,
                  iconColor: const Color(0xff1F91E1),
                ),
                const SizedBox(
                  width: 40,
                ),
                const IconTextButton(
                  text: "Rate Us",
                  icon: Icons.star,
                  iconColor: Color(0xffF5D329),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
