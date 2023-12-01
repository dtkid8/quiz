import 'package:flutter_bloc/flutter_bloc.dart';

class TopicSaveCubit extends Cubit<String> {
  TopicSaveCubit() : super("animal");

  save(String topic) {
    emit(topic);
  }
}
