import 'package:flutter/material.dart';
import 'package:voxify/models/exercise_model.dart';

class OrderSyllablesExerciseView extends StatefulWidget {
  final ExerciseModel exercise;
  final ValueChanged<bool> onAnswered;

  const OrderSyllablesExerciseView({
    super.key,
    required this.exercise,
    required this.onAnswered,
  });

  @override
  State<OrderSyllablesExerciseView> createState() =>
      _OrderSyllablesExerciseViewState();
}

class _OrderSyllablesExerciseViewState
    extends State<OrderSyllablesExerciseView> {
  final List<int> _selectedIndices = [];
  bool _submitted = false;

  String get _formedWord =>
      _selectedIndices.map((index) => widget.exercise.syllables[index]).join();

  void _submit() {
    if (_submitted || _selectedIndices.isEmpty) return;
    setState(() => _submitted = true);
    widget.onAnswered(widget.exercise.isCorrect(_formedWord));
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
        const SizedBox(height: 24),
        Container(
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.deepPurple.shade100),
          ),
          alignment: Alignment.center,
          child: Text(
            _selectedIndices.isEmpty ? 'Toque nas sílabas abaixo' : _formedWord,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            for (
              var index = 0;
              index < widget.exercise.syllables.length;
              index++
            )
              ActionChip(
                label: Text(widget.exercise.syllables[index]),
                onPressed: _submitted || _selectedIndices.contains(index)
                    ? null
                    : () => setState(() => _selectedIndices.add(index)),
              ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            TextButton.icon(
              onPressed: _submitted || _selectedIndices.isEmpty
                  ? null
                  : () => setState(() => _selectedIndices.removeLast()),
              icon: const Icon(Icons.undo_rounded),
              label: const Text('Desfazer'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _submitted ? null : _submit,
              child: const Text('Verificar'),
            ),
          ],
        ),
      ],
    );
  }
}
