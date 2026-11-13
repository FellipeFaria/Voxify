import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voxify/models/exercise_model.dart';

class AudioSpeakExerciseView extends StatefulWidget {
  final ExerciseModel exercise;
  final ValueChanged<bool> onAnswered;

  const AudioSpeakExerciseView({
    super.key,
    required this.exercise,
    required this.onAnswered,
  });

  @override
  State<AudioSpeakExerciseView> createState() => _AudioSpeakExerciseViewState();
}

class _AudioSpeakExerciseViewState extends State<AudioSpeakExerciseView> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  String _transcript = '';
  String? _errorMessage;
  bool _isRecording = false;
  bool _isInitializing = false;
  bool _submitted = false;

  Future<void> _playModel() async {
    try {
      await _tts.setLanguage('pt-BR');
      await _tts.speak(
        widget.exercise.audioPrompt ?? widget.exercise.correctAnswer,
      );
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = 'Falha ao reproduzir áudio: $error');
      }
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      try {
        await _speech.stop();
      } catch (error) {
        if (mounted) {
          setState(
            () => _errorMessage = 'Não foi possível parar a gravação: $error',
          );
        }
      } finally {
        if (mounted) setState(() => _isRecording = false);
      }
      return;
    }

    setState(() {
      _isInitializing = true;
      _errorMessage = null;
      _transcript = '';
    });
    try {
      final available = await _speech.initialize(
        onError: (error) {
          if (mounted) {
            setState(() {
              _isRecording = false;
              _errorMessage = 'Reconhecimento de fala: ${error.errorMsg}';
            });
          }
        },
      );
      if (!mounted) return;
      if (!available) {
        setState(() {
          _isInitializing = false;
          _errorMessage =
              'Reconhecimento de fala indisponível neste dispositivo.';
        });
        return;
      }

      setState(() {
        _isInitializing = false;
        _isRecording = true;
      });
      await _speech.listen(
        listenOptions: SpeechListenOptions(
          localeId: 'pt_BR',
          listenFor: const Duration(seconds: 10),
          pauseFor: const Duration(seconds: 3),
          partialResults: false,
          onDevice: true,
          cancelOnError: true,
          listenMode: ListenMode.dictation,
        ),
        onResult: (result) {
          if (mounted) {
            setState(() {
              _transcript = result.recognizedWords;
              if (result.finalResult) _isRecording = false;
            });
          }
        },
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _isRecording = false;
          _errorMessage = 'Não foi possível iniciar o microfone: $error';
        });
      }
    }
  }

  void _validateAttempt() {
    if (_submitted || _transcript.trim().isEmpty) return;
    setState(() => _submitted = true);
    widget.onAnswered(widget.exercise.matchesSpeech(_transcript));
  }

  @override
  void dispose() {
    _speech.cancel();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.exercise.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.exercise.question,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: _playModel,
          icon: const Icon(Icons.volume_up_rounded),
          label: const Text('Ouvir modelo'),
        ),
        const SizedBox(height: 24),
        IconButton.filled(
          onPressed: _isInitializing || _submitted ? null : _toggleRecording,
          iconSize: 42,
          style: IconButton.styleFrom(
            backgroundColor: _isRecording ? Colors.redAccent : Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(22),
          ),
          icon: _isInitializing
              ? const SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Icon(_isRecording ? Icons.stop_rounded : Icons.mic_rounded),
        ),
        const SizedBox(height: 12),
        Text(
          _isRecording ? 'Ouvindo... toque para parar' : 'Toque para gravar',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        if (_transcript.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Você disse: “$_transcript”', textAlign: TextAlign.center),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _submitted || _isRecording ? null : _validateAttempt,
            child: const Text('Validar tentativa'),
          ),
        ],
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}
