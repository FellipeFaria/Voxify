import 'package:flutter/material.dart';
import 'package:voxify/models/exercise_model.dart';

class AudioSpeakExerciseView extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onNext;

  const AudioSpeakExerciseView({
    super.key,
    required this.exercise,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          exercise.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),

        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Reproduzindo áudio: ${exercise.audioPrompt ?? "padrão"}',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.volume_up_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 30),

        Text(
          exercise.question,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 40),

        // Botão de Microfone
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gravando voz... Analisando fonema...'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.mic_rounded, color: Colors.white, size: 45),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Toque para falar',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
