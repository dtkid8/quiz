import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/common/widget/app_bar/quiz_app_bar.dart';
import 'package:quiz/feature/topic/topic_cubit.dart';
import 'package:quiz/feature/topic/topic_model.dart';
import 'package:quiz/feature/topic/topic_repository.dart';
import 'package:quiz/feature/topic/topic_save_cubit.dart';

import '../../common/general_state.dart';

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TopicCubit(repository: context.read<TopicRepository>()),
      child: const TopicView(),
    );
  }
}

class TopicView extends StatefulWidget {
  const TopicView({super.key});

  @override
  State<TopicView> createState() => _TopicViewState();
}

class _TopicViewState extends State<TopicView> {
  @override
  void initState() {
    super.initState();
    context.read<TopicCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: QuizAppBar(title: "Topics", backgroundColor: backgroundColor),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              onSubmitted: (value) {
                if (value.isNotEmpty) context.read<TopicCubit>().search(value);
              },
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<TopicCubit, GeneralState>(
              builder: (context, state) {
                if (state is GeneralLoadedState) {
                  final TopicModel topic = state.data;
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: topic.data
                                ?.map((e) => TopicCard(
                                      title: e.name ?? "",
                                      onTap: () {
                                        context
                                            .read<TopicSaveCubit>()
                                            .save(e.name?.toLowerCase() ?? "");
                                      },
                                    ))
                                .toList() ??
                            [],
                      ),
                    ],
                  );
                } else if (state is GeneralLoadingState) {
                  return const Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CircularProgressIndicator(),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TopicCard extends StatelessWidget {
  final String title;
  final Function? onTap;
  const TopicCard({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: const Color(0xff193469),
            borderRadius: BorderRadius.circular(8)),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
