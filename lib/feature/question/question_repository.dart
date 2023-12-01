import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'question_model.dart';

class QuestionRepository {
  final ref = FirebaseDatabase.instance.ref();
  Future getQuestions(String topic) async {
    final snapshot = await ref.child('question/$topic').get();
    if (snapshot.exists) {
      final data = jsonDecode(jsonEncode(snapshot.value));
      return QuestionModel.fromJson(data);
    }
  }
}
