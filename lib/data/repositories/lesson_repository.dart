import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxify/models/exercise_model.dart';
import 'package:voxify/models/unit_model.dart';

class LessonRepository {
  final FirebaseFirestore _firestore;

  LessonRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _units =>
      _firestore.collection('units');

  static const Map<String, Map<String, dynamic>> defaultUnitLessons = {
    'lesson_1': {
      'id': 'lesson_1',
      'title': 'Conhecendo o /R/ Brando',
      'description':
          'Reconheça o som do R brando e pratique sua produção isolada.',
      'type': 'practice',
      'xpReward': 50,
      'isLocked': false,
      'order': 1,
      'exercises': [
        {
          'id': 'l1-e1',
          'type': 'multiple_choice',
          'title': 'Reconheça o som',
          'question': 'Qual palavra tem o R brando entre vogais?',
          'alternatives': ['Rato', 'Pera', 'Carro', 'Honra'],
          'correctAnswer': 'Pera',
        },
        {
          'id': 'l1-e2',
          'type': 'listen_and_repeat',
          'title': 'Repita o som',
          'question': 'Ouça e repita: arara.',
          'audioPrompt': 'arara',
          'correctAnswer': 'arara',
        },
      ],
    },
    'lesson_2': {
      'id': 'lesson_2',
      'title': 'Prática do som isolado',
      'description': 'Pratique a articulação do fonema em diferentes posições.',
      'type': 'practice',
      'xpReward': 50,
      'isLocked': true,
      'order': 2,
      'exercises': [
        {
          'id': 'l2-e1',
          'type': 'listen_and_repeat',
          'title': 'Repetição guiada',
          'question': 'Ouça e repita: arara.',
          'audioPrompt': 'arara',
          'correctAnswer': 'arara',
        },
        {
          'id': 'l2-e2',
          'type': 'multiple_choice',
          'title': 'Escolha a palavra',
          'question': 'Em qual palavra o R tem som brando?',
          'alternatives': ['rua', 'barata', 'carro', 'honra'],
          'correctAnswer': 'barata',
        },
      ],
    },
    'lesson_3': {
      'id': 'lesson_3',
      'title': 'O /R/ entre vogais',
      'description': 'Identifique e produza o fonema em palavras simples.',
      'type': 'practice',
      'xpReward': 50,
      'isLocked': true,
      'order': 3,
      'exercises': [
        {
          'id': 'l3-e1',
          'type': 'minimal_pairs',
          'title': 'Ouça e diferencie',
          'question': 'Qual palavra você ouviu?',
          'audioPrompt': 'cora',
          'alternatives': ['Cora', 'Cola', 'Coro', 'Cota'],
          'correctAnswer': 'Cora',
        },
        {
          'id': 'l3-e2',
          'type': 'order_syllables',
          'title': 'Monte a palavra',
          'question': 'Organize as sílabas para formar o nome da ave.',
          'syllables': ['ra', 'a', 'ra'],
          'correctAnswer': 'arara',
        },
      ],
    },
    'lesson_4': {
      'id': 'lesson_4',
      'title': 'Revisão 1: primeiros sons',
      'description':
          'Revise reconhecimento, escuta e produção das aulas anteriores. Sem perda de vidas.',
      'type': 'revision',
      'xpReward': 30,
      'isLocked': true,
      'order': 4,
      'exercises': [
        {
          'id': 'l4-e1',
          'type': 'multiple_choice',
          'title': 'Revisão de reconhecimento',
          'question': 'Qual palavra apresenta o R brando?',
          'alternatives': ['rato', 'pera', 'carro', 'honra'],
          'correctAnswer': 'pera',
        },
        {
          'id': 'l4-e2',
          'type': 'listen_and_repeat',
          'title': 'Revisão de produção',
          'question': 'Ouça e repita: barata.',
          'audioPrompt': 'barata',
          'correctAnswer': 'barata',
        },
        {
          'id': 'l4-e3',
          'type': 'minimal_pairs',
          'title': 'Revisão auditiva',
          'question': 'Escolha a palavra que corresponde ao áudio.',
          'audioPrompt': 'cora',
          'alternatives': ['Cora', 'Cola'],
          'correctAnswer': 'Cora',
        },
      ],
    },
    'lesson_5': {
      'id': 'lesson_5',
      'title': 'Palavras com mais sílabas',
      'description':
          'Pratique palavras maiores e complete frases com o fonema-alvo.',
      'type': 'practice',
      'xpReward': 50,
      'isLocked': true,
      'order': 5,
      'exercises': [
        {
          'id': 'l5-e1',
          'type': 'order_syllables',
          'title': 'Ordene as sílabas',
          'question': 'Forme a palavra "careta".',
          'syllables': ['ta', 'ca', 're'],
          'correctAnswer': 'careta',
        },
        {
          'id': 'l5-e2',
          'type': 'fill_in_the_blank',
          'title': 'Complete a frase',
          'question': 'A ____ voa pelo céu.',
          'alternatives': ['arara', 'aranha', 'águia', 'andorinha'],
          'correctAnswer': 'arara',
        },
      ],
    },
    'lesson_6': {
      'id': 'lesson_6',
      'title': 'Ritmo e velocidade',
      'description':
          'Mantenha a clareza do fonema ao falar em ritmo confortável.',
      'type': 'practice',
      'xpReward': 50,
      'isLocked': true,
      'order': 6,
      'exercises': [
        {
          'id': 'l6-e1',
          'type': 'listen_and_repeat',
          'title': 'Ritmo controlado',
          'question': 'Ouça e repita com clareza: barata, careta, arara.',
          'audioPrompt': 'barata, careta, arara',
          'correctAnswer': 'barata careta arara',
        },
        {
          'id': 'l6-e2',
          'type': 'fill_in_the_blank',
          'title': 'Complete a frase',
          'question': 'A menina ____ perto da janela.',
          'alternatives': ['mora', 'mola', 'muda', 'nada'],
          'correctAnswer': 'mora',
        },
      ],
    },
    'lesson_7': {
      'id': 'lesson_7',
      'title': 'Pares mínimos',
      'description':
          'Diferencie palavras parecidas e perceba a mudança de significado.',
      'type': 'practice',
      'xpReward': 50,
      'isLocked': true,
      'order': 7,
      'exercises': [
        {
          'id': 'l7-e1',
          'type': 'minimal_pairs',
          'title': 'Cora ou cola?',
          'question': 'Ouça e escolha a palavra correspondente.',
          'audioPrompt': 'cora',
          'alternatives': ['Cora', 'Cola'],
          'correctAnswer': 'Cora',
        },
        {
          'id': 'l7-e2',
          'type': 'multiple_choice',
          'title': 'Compare os sons',
          'question': 'Qual palavra tem R brando, e não L?',
          'alternatives': ['mala', 'mara', 'mola', 'mula'],
          'correctAnswer': 'mara',
        },
      ],
    },
    'lesson_8': {
      'id': 'lesson_8',
      'title': 'Revisão 2: desafio misto',
      'description':
          'Combine escuta, construção de palavras e frases. Sem perda de vidas.',
      'type': 'revision',
      'xpReward': 30,
      'isLocked': true,
      'order': 8,
      'exercises': [
        {
          'id': 'l8-e1',
          'type': 'minimal_pairs',
          'title': 'Discriminação auditiva',
          'question': 'Qual palavra você ouviu?',
          'audioPrompt': 'cora',
          'alternatives': ['Cora', 'Cola'],
          'correctAnswer': 'Cora',
        },
        {
          'id': 'l8-e2',
          'type': 'fill_in_the_blank',
          'title': 'Complete a frase',
          'question': 'O ____ está no jardim.',
          'alternatives': ['carro', 'gato', 'rato', 'livro'],
          'correctAnswer': 'rato',
        },
        {
          'id': 'l8-e3',
          'type': 'order_syllables',
          'title': 'Desafio de sílabas',
          'question': 'Forme a palavra "careta".',
          'syllables': ['re', 'ta', 'ca'],
          'correctAnswer': 'careta',
        },
      ],
    },
    'lesson_9': {
      'id': 'lesson_9',
      'title': 'Frases e trava-línguas',
      'description':
          'Leve o fonema para frases curtas e uma sequência de fala.',
      'type': 'practice',
      'xpReward': 50,
      'isLocked': true,
      'order': 9,
      'exercises': [
        {
          'id': 'l9-e1',
          'type': 'listen_and_repeat',
          'title': 'Frase curta',
          'question': 'Repita: A arara mora perto da amoreira.',
          'audioPrompt': 'A arara mora perto da amoreira.',
          'correctAnswer': 'A arara mora perto da amoreira',
        },
        {
          'id': 'l9-e2',
          'type': 'listen_and_repeat',
          'title': 'Trava-línguas',
          'question': 'Repita: O rato roeu a roupa da rainha de Roma.',
          'audioPrompt': 'O rato roeu a roupa da rainha de Roma.',
          'correctAnswer': 'O rato roeu a roupa da rainha de Roma',
        },
      ],
    },
    'lesson_10': {
      'id': 'lesson_10',
      'title': 'Mini-Prova da Unidade',
      'description':
          'Checkpoint acumulativo. Acerte pelo menos 80% para concluir e liberar a próxima unidade.',
      'type': 'mini_test',
      'xpReward': 100,
      'isLocked': true,
      'order': 10,
      'passingScore': 0.8,
      'exercises': [
        {
          'id': 'l10-e1',
          'type': 'multiple_choice',
          'title': 'Reconhecimento',
          'question': 'Qual palavra contém o R brando?',
          'alternatives': ['rato', 'pera', 'carro', 'honra'],
          'correctAnswer': 'pera',
        },
        {
          'id': 'l10-e2',
          'type': 'minimal_pairs',
          'title': 'Pares mínimos',
          'question': 'Ouça e escolha a palavra.',
          'audioPrompt': 'cora',
          'alternatives': ['Cora', 'Cola'],
          'correctAnswer': 'Cora',
        },
        {
          'id': 'l10-e3',
          'type': 'fill_in_the_blank',
          'title': 'Complete a frase',
          'question': 'A ____ mora na floresta.',
          'alternatives': ['arara', 'águia', 'aranha', 'abelha'],
          'correctAnswer': 'arara',
        },
        {
          'id': 'l10-e4',
          'type': 'order_syllables',
          'title': 'Organize as sílabas',
          'question': 'Forme a palavra "careta".',
          'syllables': ['re', 'ca', 'ta'],
          'correctAnswer': 'careta',
        },
        {
          'id': 'l10-e5',
          'type': 'listen_and_repeat',
          'title': 'Produção final',
          'question': 'Repita: A arara mora perto da amoreira.',
          'audioPrompt': 'A arara mora perto da amoreira.',
          'correctAnswer': 'A arara mora perto da amoreira',
        },
      ],
    },
  };

  Future<void> ensureDefaultUnit() async {
    const unitId = 'unit_1';
    const schemaVersion = 2;
    final lessons = defaultUnitLessons;

    final unitRef = _units.doc(unitId);
    final unitSnapshot = await unitRef.get();
    final lessonsRef = unitRef.collection('lessons');
    final existingLessons = await lessonsRef.get();
    final currentVersion =
        (unitSnapshot.data()?['schemaVersion'] as num?)?.toInt() ?? 0;
    final migratingSchema = currentVersion < schemaVersion;
    final existingIds = existingLessons.docs.map((doc) => doc.id).toSet();
    final missingIds = lessons.keys.where((id) => !existingIds.contains(id));
    final extraDocuments = existingLessons.docs
        .where((doc) => !lessons.containsKey(doc.id))
        .toList();
    if (!migratingSchema && missingIds.isEmpty && extraDocuments.isEmpty) {
      return;
    }

    final batch = _firestore.batch();
    if (migratingSchema) {
      batch.set(unitRef, {
        'id': unitId,
        'title': 'Fonema /R/ Brando',
        'description': 'Pratique o Fonema /R/ Brando em 10 aulas progressivas.',
        'order': 1,
        'schemaVersion': schemaVersion,
      }, SetOptions(merge: true));
    }
    for (final entry in lessons.entries) {
      if (migratingSchema || !existingIds.contains(entry.key)) {
        batch.set(lessonsRef.doc(entry.key), entry.value);
      }
    }
    for (final document in extraDocuments) {
      batch.delete(document.reference);
    }
    await batch.commit();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchUnits() =>
      _units.orderBy('order').snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> watchLessons(String unitId) =>
      _units.doc(unitId).collection('lessons').orderBy('order').snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUser(String uid) =>
      _firestore.collection('users').doc(uid).snapshots();

  Future<bool> completeLesson({
    required String uid,
    required UnitModel unit,
    required LessonModel lesson,
    required double score,
  }) {
    final userRef = _firestore.collection('users').doc(uid);
    final previousIndex = unit.lessons.indexWhere(
      (item) => item.id == lesson.id,
    );
    if (previousIndex < 0) {
      throw StateError('A aula não pertence à unidade informada.');
    }
    final prerequisiteId = previousIndex > 0
        ? unit.lessons[previousIndex - 1].id
        : null;

    return _firestore.runTransaction<bool>((transaction) async {
      final userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) {
        throw StateError('Perfil do usuário não encontrado.');
      }

      final userData = userSnapshot.data()!;
      if (lesson.type == 'mini_test' && score < lesson.passingScore) {
        throw StateError(
          'A mini-prova exige pelo menos '
          '${(lesson.passingScore * 100).round()}% de acertos.',
        );
      }
      final completedIds = List<String>.from(
        userData['completedLessonIds'] as List? ?? [],
      );
      if (completedIds.contains(lesson.id)) return false;
      if (prerequisiteId != null && !completedIds.contains(prerequisiteId)) {
        throw StateError('Conclua a aula anterior antes de continuar.');
      }

      completedIds.add(lesson.id);
      final lessonProgress = Map<String, dynamic>.from(
        userData['lessonProgress'] as Map? ?? {},
      );
      lessonProgress[lesson.id] = {
        'concluido': true,
        'score': score,
        'completedAt': FieldValue.serverTimestamp(),
      };
      final unlockedUnitIds = List<String>.from(
        userData['unlockedUnitIds'] as List? ?? ['unit_1'],
      );
      final totalXp =
          ((userData['xp'] as num?)?.toInt() ?? 0) + lesson.xpReward;
      final updates = <String, dynamic>{
        'completedLessonIds': completedIds,
        'lessonProgress': lessonProgress,
        'unlockedUnitIds': unlockedUnitIds,
        'xp': totalXp,
        'level': (totalXp ~/ 100) + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (lesson.type == 'mini_test' &&
          unit.lessons.isNotEmpty &&
          unit.lessons.last.id == lesson.id) {
        final nextUnitId = 'unit_${unit.order + 1}';
        if (!unlockedUnitIds.contains(nextUnitId)) {
          unlockedUnitIds.add(nextUnitId);
        }
      }

      transaction.update(userRef, updates);
      return true;
    });
  }

  Future<int> consumeLife(String uid) {
    final userRef = _firestore.collection('users').doc(uid);
    return _firestore.runTransaction<int>((transaction) async {
      final userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) {
        throw StateError('Perfil do usuário não encontrado.');
      }

      final currentHealth =
          (userSnapshot.data()?['health'] as num?)?.toInt() ?? 5;
      final remainingHealth = currentHealth > 0 ? currentHealth - 1 : 0;
      if (remainingHealth != currentHealth) {
        transaction.update(userRef, {'health': remainingHealth});
      }
      return remainingHealth;
    });
  }
}
