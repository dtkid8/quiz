import 'dart:async';

import 'package:quiz/common/general_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/feature/question/question_model.dart';
import 'question_repository.dart';

// class QuestionLoadedModel {
//   final QuestionModel question;
//   final double timer;
//   QuestionLoadedModel({
//     required this.question,
//     required this.timer,
//   });
// }

class QuestionCubit extends Cubit<GeneralState> {
  final QuestionRepository repository;
  // late Timer _timer;
  QuestionCubit({
    required this.repository,
  }) : super(GeneralInitializeState());

  void initialize(String topic) async {
    emit(GeneralLoadingState());
    Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        final QuestionModel question = await repository.getQuestions(topic);
        question.data?.shuffle();
        emit(GeneralLoadedState(question));
      } catch (e) {
        emit(GeneralErrorState(e.toString()));
      }
    });
  }
}
