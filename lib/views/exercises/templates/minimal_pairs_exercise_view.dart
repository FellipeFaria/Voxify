import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:voxify/models/exercise_model.dart';

class MinimalPairsExerciseView extends StatefulWidget {
  final ExerciseModel exercise;
  final ValueChanged<bool> onAnswered;

  const MinimalPairsExerciseView({
    super.key,
    required this.exercise,
    required this.onAnswered,
  });

  @override
  State<MinimalPairsExerciseView> createState() =>
      _MinimalPairsExerciseViewState();
}

class _MinimalPairsExerciseViewState extends State<MinimalPairsExerciseView> {
  final FlutterTts _tts = FlutterTts();
  String? _selectedAnswer;
  bool _submitted = false;
  bool _isSpeaking = false;
  String? _errorMessage;

  Future<void> _playPrompt() async {
    setState(() => _isSpeaking = true);
    try {
      await _tts.setLanguage('pt-BR');
      await _tts.speak(
        widget.exercise.audioPrompt ?? widget.exercise.correctAnswer,
      );
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = 'Falha ao reproduzir áudio: $error');
      }
    } finally {
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  void _submit() {
    final selectedAnswer = _selectedAnswer;
    if (selectedAnswer == null || _submitted) return;
    setState(() => _submitted = true);
    widget.onAnswered(widget.exercise.isCorrect(selectedAnswer));
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.exercise.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.exercise.question,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: _isSpeaking ? null : _playPrompt,
          icon: const Icon(Icons.volume_up_rounded),
          label: const Text('Ouvir o som-alvo'),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            itemCount: widget.exercise.alternatives.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final word = widget.exercise.alternatives[index];
              final selected = _selectedAnswer == word;
              final image = index < widget.exercise.alternativeImages.length
                  ? widget.exercise.alternativeImages[index]
                  : '';
              return OutlinedButton(
                onPressed: _submitted
                    ? null
                    : () => setState(() => _selectedAnswer = word),
                style: OutlinedButton.styleFrom(
                  backgroundColor: selected
                      ? Colors.deepPurple.shade50
                      : Colors.white,
                  side: BorderSide(
                    color: selected ? Colors.deepPurple : Colors.grey.shade300,
                    width: selected ? 2 : 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (image.isNotEmpty)
                      Image.network(
                        image,
                        height: 54,
                        width: 54,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.image_not_supported_outlined),
                      )
                    else
                      const Icon(
                        Icons.graphic_eq_rounded,
                        color: Colors.deepPurple,
                        size: 36,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      word,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        FilledButton(
          onPressed: _selectedAnswer == null || _submitted ? null : _submit,
          child: const Text('Confirmar palavra'),
        ),
      ],
    );
  }
}
