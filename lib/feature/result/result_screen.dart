import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz/common/widget/app_bar/quiz_app_bar.dart';
import 'package:quiz/feature/result/result_model.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatefulWidget {
  final List<ResultModel> result;
  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final int correct =
        widget.result.where((element) => element.isCorrect).toList().length;
    final int total = widget.result.length;
    final backgroundColor = Theme.of(context).primaryColor;
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: QuizAppBar(
          title: "Your Score",
          backgroundColor: backgroundColor,
          onBackTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        body: SafeArea(
            child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 150, maxWidth: 150),
                child: Stack(
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Transform.flip(
                        flipX: true,
                        child: CircularProgressIndicator(
                          strokeWidth: 8.0,
                          color: Colors.green,
                          backgroundColor: Colors.red,
                          value: correct.toDouble() / total.toDouble(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 60,
                      child: Text(
                        "$correct / $total",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  await screenshotController
                      .capture(delay: const Duration(milliseconds: 10))
                      .then((Uint8List? image) async {
                    if (image != null) {
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final imagePath =
                          await File('${directory.path}/image.png').create();
                      await imagePath.writeAsBytes(image);
                      await Share.shareXFiles(
                        [XFile(imagePath.path)],
                        text: "Your Score",
                      );
                    }
                  });
                },
                child: const Text(
                  "Share your score",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                "Your Report",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.result
                    .map(
                      (e) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.question,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          e.isCorrect
                              ? Row(
                                  children: [
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      e.validAnswer,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      e.userAnswer,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      e.validAnswer,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    )
                                  ],
                                ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        )),
      ),
    );
  }
}
