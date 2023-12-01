class QuestionModel {
  List<QuestionData>? data;
  int? count;

  QuestionModel({
    this.data,
    this.count,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        data: json["data"] == null
            ? []
            : List<QuestionData>.from(json["data"]!.map((x) => QuestionData.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "count": count,
      };
}

class QuestionData {
  String? image;
  String? question;
  String? validAnswer;
  String? answers;

  QuestionData({
    this.image,
    this.question,
    this.validAnswer,
    this.answers,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) => QuestionData(
        image: json["image"],
        question: json["question"],
        validAnswer: json["valid_answer"],
        answers: json["answers"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "question": question,
        "valid_answer": validAnswer,
        "answers": answers,
      };
}
