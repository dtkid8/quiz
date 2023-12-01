import 'package:flutter/material.dart';
import 'package:quiz/common/widget/indicator/quiz_linear_progress_indicator.dart';

class QuizAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final bool showLinearProgressIndicator;
  final List<Widget>? actions;
  final double progressIndicatorValue;
  final Function()? onBackTap;
  const QuizAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.showLinearProgressIndicator = false,
    this.actions,
    this.progressIndicatorValue = 0.0,
    this.onBackTap,
  });

  @override
  State<QuizAppBar> createState() => _QuizAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _QuizAppBarState extends State<QuizAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: widget.actions,
      backgroundColor: widget.backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: widget.onBackTap?.call ??
            () {
              Navigator.pop(context);
            },
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 18,
        ),
      ),
      centerTitle: true,
      title: Text(
        widget.title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      bottom: widget.showLinearProgressIndicator
          ? QuizLinearProgressIndicator(
              progressIndicatorValue: widget.progressIndicatorValue,
            )
          : null,
    );
  }
}
