import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/common/general_state.dart';

import '../../../feature/question/question_timer_cubit.dart';

class QuizLinearProgressIndicator extends StatefulWidget
    implements PreferredSizeWidget {
  final double progressIndicatorValue;
  const QuizLinearProgressIndicator({
    super.key,
    this.progressIndicatorValue = 0,
  });

  @override
  State<QuizLinearProgressIndicator> createState() =>
      _QuizLinearProgressIndicatorState();

  @override
  Size get preferredSize => const Size(double.infinity, 6.0);
}

class _QuizLinearProgressIndicatorState
    extends State<QuizLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionTimerCubit, GeneralState>(
        builder: (context, state) {
      return TweenAnimationBuilder<double>(
          duration: state is GeneralLoadedState
              ? const Duration(milliseconds: 500)
              : const Duration(milliseconds: 1),
          tween: Tween<double>(
            begin: 0,
            end: state is GeneralLoadedState ? state.data : 0,
          ),
          curve: Curves.easeIn,
          builder: (context, value, _) {
            return LinearProgressIndicator(
              value: value,
              color: Colors.yellow,
            );
          });
    });
  }
}
