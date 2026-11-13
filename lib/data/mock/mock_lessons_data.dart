import 'package:voxify/data/repositories/lesson_repository.dart';
import 'package:voxify/models/exercise_model.dart';

class MockLessonsData {
  static List<LessonModel> get unitOneLessons => List.unmodifiable(
    LessonRepository.defaultUnitLessons.entries.map(
      (entry) =>
          LessonModel.fromMap(entry.value, id: entry.key, unitId: 'unit_1'),
    ),
  );
}
