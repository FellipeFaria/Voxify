import 'package:flutter/material.dart';
import 'package:voxify/models/exercise_model.dart';

class MultipleChoiceExerciseView extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onNext;

  const MultipleChoiceExerciseView({
    super.key,
    required this.exercise,
    required this.onNext,
  });

  @override
  State<MultipleChoiceExerciseView> createState() =>
      _MultipleChoiceExerciseViewState();
}

class _MultipleChoiceExerciseViewState
    extends State<MultipleChoiceExerciseView> {
  String? _alternativaSelecionada;

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
              final alt = widget.exercise.alternatives[index];
              final bool isSelected = _alternativaSelecionada == alt;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Colors.deepPurple.shade50
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.deepPurple
                          : Colors.deepPurple.shade200,
                      width: isSelected ? 2.5 : 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _alternativaSelecionada = alt;
                    });
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      alt,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
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
      ],
    );
  }
}
