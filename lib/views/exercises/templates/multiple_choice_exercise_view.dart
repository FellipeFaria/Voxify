import 'package:flutter/material.dart';
import 'package:voxify/models/exercise_model.dart';

class MultipleChoiceExerciseView extends StatefulWidget {
  final ExerciseModel exercise;
  final ValueChanged<bool> onAnswered;

  const MultipleChoiceExerciseView({
    super.key,
    required this.exercise,
    required this.onAnswered,
  });

  @override
  State<MultipleChoiceExerciseView> createState() =>
      _MultipleChoiceExerciseViewState();
}

class _MultipleChoiceExerciseViewState
    extends State<MultipleChoiceExerciseView> {
  String? _selectedAnswer;
  bool _submitted = false;

  void _submit() {
    final selectedAnswer = _selectedAnswer;
    if (selectedAnswer == null || _submitted) return;
    setState(() => _submitted = true);
    widget.onAnswered(widget.exercise.isCorrect(selectedAnswer));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: widget.exercise.alternatives.length,
            itemBuilder: (context, index) {
              final alternative = widget.exercise.alternatives[index];
              final selected = _selectedAnswer == alternative;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selected
                        ? Colors.deepPurple.shade50
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    side: BorderSide(
                      color: selected
                          ? Colors.deepPurple
                          : Colors.deepPurple.shade200,
                      width: selected ? 2.5 : 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _submitted
                      ? null
                      : () => setState(() => _selectedAnswer = alternative),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      alternative,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: selected
                            ? Colors.deepPurple.shade700
                            : Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        FilledButton(
          onPressed: _selectedAnswer == null || _submitted ? null : _submit,
          child: const Text('Confirmar resposta'),
        ),
      ],
    );
  }
}
