import 'package:flutter_test/flutter_test.dart';
import 'package:voxify/data/mock/mock_lessons_data.dart';
import 'package:voxify/models/exercise_model.dart';

void main() {
  test('unit one contains ten lessons with two reviews and a final exam', () {
    final lessons = MockLessonsData.unitOneLessons;

    expect(lessons, hasLength(10));
    expect(
      lessons.map((lesson) => lesson.order),
      orderedEquals([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
    );
    expect(lessons[3].type, 'revision');
    expect(lessons[3].xpReward, 30);
    expect(lessons[7].type, 'revision');
    expect(lessons[7].xpReward, 30);
    expect(lessons.last.type, 'mini_test');
    expect(lessons.last.xpReward, 100);
    expect(lessons.last.passingScore, 0.8);
  });

  group('ExerciseModel answer matching', () {
    test('ignores case, accents, and punctuation for typed answers', () {
      final exercise = ExerciseModel(
        id: 'fill-1',
        type: 'fill_in_the_blank',
        title: 'Complete',
        question: 'A ____ voa.',
        correctAnswer: 'arara',
      );

      expect(exercise.isCorrect(' ÁRARA! '), isTrue);
    });

    test('accepts a transcript with harmless extra words', () {
      final exercise = ExerciseModel(
        id: 'repeat-1',
        type: 'listen_and_repeat',
        title: 'Repita',
        question: 'Repita arara mora.',
        correctAnswer: 'arara mora',
      );

      expect(exercise.matchesSpeech('A arara mora.'), isTrue);
    });

    test('rejects a transcript that substitutes the target R word', () {
      final exercise = ExerciseModel(
        id: 'repeat-2',
        type: 'listen_and_repeat',
        title: 'Repita',
        question: 'Repita arara mora.',
        correctAnswer: 'arara mora',
      );

      expect(exercise.matchesSpeech('A cola mora.'), isFalse);
    });
  });
}
