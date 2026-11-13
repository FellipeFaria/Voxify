class ExerciseModel {
  final String id;
  final String type;
  final String title;
  final String question;
  final String? audioPrompt;
  final List<String> alternatives;
  final List<String> alternativeImages;
  final List<String> syllables;
  final String correctAnswer;

  ExerciseModel({
    required this.id,
    required this.type,
    required this.title,
    required this.question,
    this.audioPrompt,
    this.alternatives = const [],
    this.alternativeImages = const [],
    this.syllables = const [],
    this.correctAnswer = '',
  });

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      id: map['id'] as String? ?? '',
      type: map['type'] as String? ?? '',
      title: map['title'] as String? ?? '',
      question: map['question'] as String? ?? '',
      audioPrompt: map['audioPrompt'] as String?,
      alternatives: List<String>.from(map['alternatives'] as List? ?? []),
      alternativeImages: List<String>.from(
        map['alternativeImages'] as List? ?? [],
      ),
      syllables: List<String>.from(map['syllables'] as List? ?? []),
      correctAnswer: map['correctAnswer'] as String? ?? '',
    );
  }

  bool isCorrect(String response) =>
      normalizeExerciseAnswer(response) ==
      normalizeExerciseAnswer(correctAnswer);

  bool matchesSpeech(String response) {
    final target = normalizeExerciseAnswer(correctAnswer);
    final transcript = normalizeExerciseAnswer(response);
    if (target.isEmpty || transcript.isEmpty) return false;
    final targetWords = target.split(' ');
    final transcriptWords = transcript.split(' ');
    final targetPhonemeWords = targetWords.where((word) => word.contains('r'));
    if (targetPhonemeWords.any((word) => !transcriptWords.contains(word))) {
      return false;
    }

    final distance = _levenshteinDistance(
      targetWords.join(' '),
      transcriptWords.join(' '),
    );
    final similarity = 1 - distance / target.length;
    return similarity >= 0.75;
  }
}

class LessonModel {
  final String id;
  final String unitId;
  final String tituloAula;
  final String description;
  final String type;
  final int xpReward;
  final bool isLocked;
  final int order;
  final double passingScore;
  final List<ExerciseModel> exercises;

  LessonModel({
    this.id = '',
    this.unitId = '',
    required this.tituloAula,
    this.description = '',
    this.type = 'pronunciation',
    this.xpReward = 50,
    this.isLocked = false,
    this.order = 0,
    this.passingScore = 0.8,
    required this.exercises,
  });

  factory LessonModel.fromMap(
    Map<String, dynamic> map, {
    String id = '',
    String unitId = '',
  }) {
    final rawList = map['exercises'] ?? map['exercicios'] ?? [];
    final exercises = (rawList as List)
        .map(
          (item) =>
              ExerciseModel.fromMap(Map<String, dynamic>.from(item as Map)),
        )
        .toList();

    return LessonModel(
      id: id,
      unitId: unitId,
      tituloAula: map['title'] as String? ?? map['tituloAula'] as String? ?? '',
      description: map['description'] as String? ?? '',
      type: map['type'] as String? ?? 'pronunciation',
      xpReward: (map['xpReward'] as num?)?.toInt() ?? 50,
      isLocked: map['isLocked'] as bool? ?? false,
      order: (map['order'] as num?)?.toInt() ?? 0,
      passingScore: (map['passingScore'] as num?)?.toDouble() ?? 0.8,
      exercises: exercises,
    );
  }
}

String normalizeExerciseAnswer(String value) {
  const accentMap = {
    'á': 'a',
    'à': 'a',
    'ã': 'a',
    'â': 'a',
    'é': 'e',
    'ê': 'e',
    'í': 'i',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ú': 'u',
    'ü': 'u',
    'ç': 'c',
  };
  var normalized = value.toLowerCase().trim();
  for (final entry in accentMap.entries) {
    normalized = normalized.replaceAll(entry.key, entry.value);
  }
  return normalized
      .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

int _levenshteinDistance(String first, String second) {
  var previousRow = List<int>.generate(second.length + 1, (index) => index);
  for (var i = 0; i < first.length; i++) {
    final currentRow = List<int>.filled(second.length + 1, 0);
    currentRow[0] = i + 1;
    for (var j = 0; j < second.length; j++) {
      final substitutionCost = first[i] == second[j] ? 0 : 1;
      currentRow[j + 1] = [
        currentRow[j] + 1,
        previousRow[j + 1] + 1,
        previousRow[j] + substitutionCost,
      ].reduce((a, b) => a < b ? a : b);
    }
    previousRow = currentRow;
  }
  return previousRow.last;
}
