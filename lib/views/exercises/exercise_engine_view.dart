import 'package:flutter/material.dart';
import 'package:voxify/models/exercise_model.dart';
import 'package:voxify/views/exercises/templates/audio_speak_exercise_view.dart';
import 'package:voxify/views/exercises/templates/multiple_choice_exercise_view.dart';

class ExerciseEngineView extends StatefulWidget {
  final LessonModel lesson;

  const ExerciseEngineView({super.key, required this.lesson});

  @override
  State<ExerciseEngineView> createState() => _ExerciseEngineViewState();
}

class _ExerciseEngineViewState extends State<ExerciseEngineView> {
  int _currentIndex = 0;

  void _nextExercise() {
    if (_currentIndex < widget.lesson.exercises.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parabéns! Aula concluída e +50 XP adicionados!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lesson.exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.lesson.tituloAula)),
        body: const Center(
          child: Text('Nenhum exercício cadastrado para esta aula.'),
        ),
      );
    }

    final currentExercise = widget.lesson.exercises[_currentIndex];
    final double progress =
        (_currentIndex + 1) / widget.lesson.exercises.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Roteamento inteligente baseado estritamente na propriedade 'type' do model
            Expanded(
              child: currentExercise.type == 'audio_fala'
                  ? AudioSpeakExerciseView(
                      exercise: currentExercise,
                      onNext: _nextExercise,
                    )
                  : MultipleChoiceExerciseView(
                      exercise: currentExercise,
                      onNext: _nextExercise,
                    ),
            ),

            SizedBox(
              height: 54,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _nextExercise,
                child: Text(
                  _currentIndex == widget.lesson.exercises.length - 1
                      ? 'CONCLUIR AULA'
                      : 'PRÓXIMO',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
