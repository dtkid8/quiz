import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/feature/home/home_screen.dart';
import 'package:quiz/feature/question/question_repository.dart';
import 'package:quiz/feature/topic/topic_repository.dart';
import 'package:quiz/feature/topic/topic_save_cubit.dart';

import 'common/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => TopicRepository(),
      ),
      RepositoryProvider(
        create: (context) => QuestionRepository(),
      ),
    ],
    child: BlocProvider(
      create: (context) => TopicSaveCubit(),
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xff14284F),
      ),
      home: const HomeScreen(),
    );
  }
}
