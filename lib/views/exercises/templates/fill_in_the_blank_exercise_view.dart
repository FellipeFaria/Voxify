import 'package:flutter/material.dart';
import 'package:voxify/models/exercise_model.dart';

class FillInTheBlankExerciseView extends StatefulWidget {
  final ExerciseModel exercise;
  final ValueChanged<bool> onAnswered;

  const FillInTheBlankExerciseView({
    super.key,
    required this.exercise,
    required this.onAnswered,
  });

  @override
  State<FillInTheBlankExerciseView> createState() =>
      _FillInTheBlankExerciseViewState();
}

class _FillInTheBlankExerciseViewState
    extends State<FillInTheBlankExerciseView> {
  final TextEditingController _answerController = TextEditingController();
  bool _submitted = false;

  void _submit() {
    if (_submitted || _answerController.text.trim().isEmpty) return;
    setState(() => _submitted = true);
    widget.onAnswered(widget.exercise.isCorrect(_answerController.text));
  }

  @override
  void dispose() {
    _answerController.dispose();
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
        const SizedBox(height: 18),
        Text(
          widget.exercise.question,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _answerController,
          enabled: !_submitted,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Complete a frase',
            prefixIcon: Icon(Icons.edit_rounded),
          ),
          onSubmitted: (_) => _submit(),
        ),
        const Spacer(),
        FilledButton(
          onPressed: _submitted ? null : _submit,
          child: const Text('Verificar resposta'),
        ),
      ],
    );
  }
}
