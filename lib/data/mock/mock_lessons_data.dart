import 'package:voxify/models/exercise_model.dart';

class MockLessonsData {
  static final LessonModel aulaVogais = LessonModel.fromMap({
    'tituloAula': 'Vogais e Sons Básicos',
    'exercises': [
      {
        'id': 'v1',
        'type': 'audio_fala',
        'title': 'Som Aberto',
        'question': 'Pronuncie o som aberto e prolongado da vogal: "A"',
        'audioPrompt': 'audio_a_longo.mp3',
        'alternatives': [],
        'correctAnswer': 'A',
      },
      {
        'id': 'v2',
        'type': 'multipla_escolha',
        'title': 'Identificação de Vogal',
        'question': 'Qual das palavras abaixo inicia com a vogal /E/ aberta?',
        'audioPrompt': null,
        'alternatives': ['Elefante', 'Uva', 'Igreja', 'Bola'],
        'correctAnswer': 'Elefante',
      },
    ],
  });

  static final LessonModel aulaRBrando = LessonModel.fromMap({
    'tituloAula': 'Fonema /R/ Brando',
    'exercicios': [
      {
        'id': 'r1',
        'type': 'audio_fala',
        'title': 'Vibração Intervocálica',
        'question': 'Pratique a vibração rápida da língua dizendo: "Arara"',
        'audioPrompt': 'audio_arara.mp3',
        'alternatives': [],
        'correctAnswer': 'Arara',
      },
      {
        'id': 'r2',
        'type': 'multipla_escolha',
        'title': 'Escolha da Palavra',
        'question':
            'Selecione a palavra que contém o fonema /R/ brando (intervocálico):',
        'audioPrompt': null,
        'alternatives': ['Carro', 'Pera', 'Rato', 'Honra'],
        'correctAnswer': 'Pera',
      },
    ],
  });
}
