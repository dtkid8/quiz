import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/common/general_state.dart';
import 'package:quiz/common/widget/app_bar/quiz_app_bar.dart';
import 'package:quiz/common/widget/button/quiz_button.dart';
import 'package:quiz/feature/question/question_cubit.dart';
import 'package:quiz/feature/question/question_model.dart';
import 'package:quiz/feature/question/question_repository.dart';
import 'package:quiz/feature/question/question_timer_cubit.dart';
import 'package:quiz/feature/result/result_screen.dart';
import 'package:quiz/feature/topic/topic_save_cubit.dart';

import '../result/result_model.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              QuestionCubit(repository: context.read<QuestionRepository>()),
        ),
        BlocProvider(
          create: (context) => QuestionTimerCubit(),
        )
      ],
      child: const QuestionView(),
    );
  }
}

class QuestionView extends StatefulWidget {
  const QuestionView({super.key});

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  int index = 0;
  int maxIndex = 0;
  int _count = 0;
  bool finished = false;
  List<ResultModel> questionResult = [];
  @override
  void initState() {
    super.initState();
    final String topic = context.read<TopicSaveCubit>().state;
    context.read<QuestionCubit>().initialize(topic);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).primaryColor;
    return MultiBlocListener(
      listeners: [
        BlocListener<QuestionCubit, GeneralState>(
          listener: (context, state) {
            if (state is GeneralLoadedState) {
              final QuestionModel question = state.data;
              final int loop = question.count ?? 0;
              _count = loop;
              maxIndex = loop;
              context
                  .read<QuestionTimerCubit>()
                  .initialize(duration: 30, loop: loop);
              _count -= 1;
              question.data?.forEach((element) {
                questionResult.add(
                  ResultModel(
                    question: element.question ?? "",
                    validAnswer: element.validAnswer ?? "",
                  ),
                );
              });
            }
          },
        ),
        BlocListener<QuestionTimerCubit, GeneralState>(
          listener: (context, state) {
            final bool checkToChangeQuizCard =
                state is GeneralInitializeState && _count > 0;
            final bool endOfQuizCard =
                state is GeneralInitializeState && _count == 0 && !finished;
            if (checkToChangeQuizCard) {
              context.read<QuestionTimerCubit>().refresh();
              _count -= 1;
              setState(() {
                if (index < maxIndex - 1) index += 1;
                questionResult[index].isCorrect = false;
              });
            } else if (endOfQuizCard) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(
                    result: questionResult,
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: QuizAppBar(
            title: "Questions",
            backgroundColor: backgroundColor,
            showLinearProgressIndicator: true,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Exit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<QuestionCubit, GeneralState>(
            builder: (context, state) {
              if (state is GeneralLoadedState) {
                final QuestionModel question = state.data;
                return IndexedStack(
                    index: index,
                    children: question.data?.map((e) {
                          final List<String> answers =
                              e.answers?.split(",") ?? [];
                          return ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              QuestionCard(
                                question: e.question ?? "",
                                image: e.image ?? "",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: answers
                                    .map(
                                      (e) => QuizButton(
                                        text: e,
                                        onTap: () {
                                          questionResult[index].userAnswer = e;
                                          questionResult[index].isCorrect =
                                              questionResult[index]
                                                          .validAnswer ==
                                                      e
                                                  ? true
                                                  : false;
                                          final bool changeToNextPage =
                                              index < maxIndex - 1;
                                          if (changeToNextPage) {
                                            context
                                                .read<QuestionTimerCubit>()
                                                .refresh();
                                            setState(() {
                                              index += 1;
                                              _count -= 1;
                                            });
                                          } else {
                                            finished = true;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ResultScreen(
                                                  result: questionResult,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    )
                                    .toList(),
                              )
                            ],
                          );
                        }).toList() ??
                        []);
              } else if (state is GeneralLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String question;
  final String image;
  const QuestionCard({
    super.key,
    required this.question,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              question,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 4,
            ),
            image.isNotEmpty
                ? LayoutBuilder(
                    builder: (context, constraint) {
                      final width = constraint.maxWidth;
                      return CachedNetworkImage(
                        imageUrl: image,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                              width: width,
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ));
                        },
                        placeholder: (context, url) {
                          return Container(
                            color: Colors.white,
                            width: width,
                            height: 200,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        },
                        height: 200,
                        width: width,
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
