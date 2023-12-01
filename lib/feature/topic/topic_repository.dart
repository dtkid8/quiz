import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:quiz/feature/topic/topic_model.dart';

class TopicRepository {
  final ref = FirebaseDatabase.instance.ref();
  
  Future getTopics() async {
    final snapshot = await ref.child('topic').get();
    if (snapshot.exists) {
      final data = jsonDecode(jsonEncode(snapshot.value));
      return TopicModel.fromJson(data);
    }
  }
}
