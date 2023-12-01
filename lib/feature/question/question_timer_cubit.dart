import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/common/general_state.dart';

class QuestionTimerCubit extends Cubit<GeneralState> {
  late Timer timer;
  int _duration = 0;
  QuestionTimerCubit() : super(GeneralInitializeState());

  void initialize({
    required int duration,
    required int loop,
  }) async {
    _duration = duration;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int remainingTime = duration - 1;
      double progressIndicatorValue = 1.0 - remainingTime / _duration;
      if (remainingTime >= 0) {
        duration--;
        emit(GeneralLoadedState(progressIndicatorValue));
      } else {
        timer.cancel();

        emit(GeneralInitializeState());
      }
    });
  }

  void refresh() async {
    timer.cancel();
    emit(GeneralLoadingState());
    int duration = _duration;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int remainingTime = duration - 1;
      double progressIndicatorValue = 1.0 - remainingTime / _duration;
      if (remainingTime >= 0) {
        duration--;
        emit(GeneralLoadedState(progressIndicatorValue));
      } else {
        timer.cancel();
        emit(GeneralInitializeState());
      }
    });
  }

  void reset() async {
    timer.cancel();
    emit(GeneralInitializeState());
  }
}
