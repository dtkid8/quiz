import 'package:quiz/common/general_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/feature/topic/topic_model.dart';
import 'package:quiz/feature/topic/topic_repository.dart';

class TopicCubit extends Cubit<GeneralState> {
  final TopicRepository repository;

  TopicCubit({
    required this.repository,
  }) : super(GeneralInitializeState());

  void initialize() async {
    emit(GeneralLoadingState());
    Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        final TopicModel topic = await repository.getTopics();
        emit(GeneralLoadedState(topic));
      } catch (e) {
        emit(GeneralErrorState(e.toString()));
      }
    });
  }

  void search(String query) async {
    emit(GeneralLoadingState());
    Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        TopicModel topic = await repository.getTopics();
        final filter = topic.data
            ?.where(((element) => element.name?.toLowerCase().contains(query.toLowerCase()) ?? false))
            .toList();
        topic.data = filter;
        emit(GeneralLoadedState(topic));
      } catch (e) {
        emit(GeneralErrorState(e.toString()));
      }
    });
  }
}
