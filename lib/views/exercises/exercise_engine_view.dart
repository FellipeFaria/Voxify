import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voxify/controllers/auth_controller.dart';
import 'package:voxify/controllers/lesson_provider.dart';
import 'package:voxify/models/exercise_model.dart';
import 'package:voxify/views/exercises/templates/audio_speak_exercise_view.dart';
import 'package:voxify/views/exercises/templates/fill_in_the_blank_exercise_view.dart';
import 'package:voxify/views/exercises/templates/minimal_pairs_exercise_view.dart';
import 'package:voxify/views/exercises/templates/multiple_choice_exercise_view.dart';
import 'package:voxify/views/exercises/templates/order_syllables_exercise_view.dart';

class ExerciseEngineView extends StatefulWidget {
  final LessonModel lesson;

  const ExerciseEngineView({super.key, required this.lesson});

  @override
  State<ExerciseEngineView> createState() => _ExerciseEngineViewState();
}

class _ExerciseEngineViewState extends State<ExerciseEngineView> {
  int _currentIndex = 0;
  int _correctAnswers = 0;
  int _attemptNumber = 0;
  bool? _currentAnswerCorrect;
  bool _isAnswerProcessing = false;
  bool _isCompleting = false;

  bool get _losesLife =>
      widget.lesson.order >= 5 && widget.lesson.type != 'revision';

  Future<void> _recordAnswer(bool correct) async {
    if (_currentAnswerCorrect != null || _isAnswerProcessing) return;
    setState(() {
      _currentAnswerCorrect = correct;
      if (correct) _correctAnswers++;
    });

    if (!correct && _losesLife) {
      setState(() => _isAnswerProcessing = true);
      final lessonProvider = context.read<LessonProvider>();
      final authController = context.read<AuthController>();
      final messenger = ScaffoldMessenger.of(context);
      try {
        final health = await lessonProvider.consumeLife();
        await authController.loadUserData();
        if (mounted && health == 0) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Você ficou sem vidas.')),
          );
        }
      } catch (error) {
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(
              content: Text('Não foi possível atualizar as vidas: $error'),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isAnswerProcessing = false);
      }
    }
  }

  Future<void> _continue() async {
    if (_currentAnswerCorrect == null || _isAnswerProcessing || _isCompleting) {
      return;
    }

    if (_currentIndex < widget.lesson.exercises.length - 1) {
      setState(() {
        _currentIndex++;
        _currentAnswerCorrect = null;
      });
      return;
    }

    final score = _correctAnswers / widget.lesson.exercises.length;
    if (widget.lesson.type == 'mini_test' &&
        score < widget.lesson.passingScore) {
      setState(() {
        _currentIndex = 0;
        _correctAnswers = 0;
        _currentAnswerCorrect = null;
        _attemptNumber++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Você acertou ${(score * 100).round()}%. '
            'Tente novamente para alcançar '
            '${(widget.lesson.passingScore * 100).round()}%.',
          ),
          backgroundColor: Colors.deepOrange,
        ),
      );
      return;
    }

    setState(() => _isCompleting = true);
    final lessonProvider = context.read<LessonProvider>();
    final authController = context.read<AuthController>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final rewarded = await lessonProvider.completeLesson(
        widget.lesson,
        score: score,
      );
      await authController.loadUserData();
      if (!mounted) return;

      navigator.pop();
      final passedUnitExam =
          widget.lesson.type == 'mini_test' &&
          widget.lesson.order ==
              lessonProvider.units
                  .firstWhere((unit) => unit.id == widget.lesson.unitId)
                  .lessons
                  .last
                  .order;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            rewarded
                ? passedUnitExam
                      ? 'Mini-prova concluída! +${widget.lesson.xpReward} XP. Próxima unidade desbloqueada!'
                      : 'Aula concluída! +${widget.lesson.xpReward} XP.'
                : 'Esta aula já foi concluída anteriormente.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('Não foi possível concluir a aula: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  Widget _buildExercise(ExerciseModel exercise) {
    final key = ValueKey('${exercise.id}-$_attemptNumber');
    switch (exercise.type) {
      case 'listen_and_repeat':
        return AudioSpeakExerciseView(
          key: key,
          exercise: exercise,
          onAnswered: _recordAnswer,
        );
      case 'multiple_choice':
        return MultipleChoiceExerciseView(
          key: key,
          exercise: exercise,
          onAnswered: _recordAnswer,
        );
      case 'minimal_pairs':
        return MinimalPairsExerciseView(
          key: key,
          exercise: exercise,
          onAnswered: _recordAnswer,
        );
      case 'fill_in_the_blank':
        return FillInTheBlankExerciseView(
          key: key,
          exercise: exercise,
          onAnswered: _recordAnswer,
        );
      case 'order_syllables':
        return OrderSyllablesExerciseView(
          key: key,
          exercise: exercise,
          onAnswered: _recordAnswer,
        );
      default:
        return Center(
          child: Text('Tipo de exercício não suportado: ${exercise.type}'),
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
    final progress = (_currentIndex + 1) / widget.lesson.exercises.length;

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.favorite_rounded, color: Colors.redAccent),
                  const SizedBox(width: 4),
                  Text('${context.watch<LessonProvider>().health}'),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildExercise(currentExercise)),
            if (_currentAnswerCorrect != null) ...[
              const SizedBox(height: 12),
              Text(
                _currentAnswerCorrect!
                    ? 'Resposta correta!'
                    : 'Resposta incorreta.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _currentAnswerCorrect!
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              height: 54,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed:
                    _currentAnswerCorrect == null ||
                        _isAnswerProcessing ||
                        _isCompleting
                    ? null
                    : _continue,
                child: _isCompleting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _currentIndex == widget.lesson.exercises.length - 1
                            ? 'CONCLUIR AULA'
                            : 'CONTINUAR',
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
