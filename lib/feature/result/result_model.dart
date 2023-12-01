class ResultModel {
  String question;
  String validAnswer;
  String userAnswer;
  bool isCorrect;
  ResultModel({
    required this.question,
    required this.validAnswer,
    this.userAnswer = "",
    this.isCorrect = false,
  });
}