import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voxify/controllers/auth_controller.dart';
import 'package:voxify/controllers/lesson_provider.dart';
import 'package:voxify/models/exercise_model.dart';
import 'package:voxify/models/unit_model.dart';
import 'package:voxify/views/exercises/exercise_engine_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<LessonProvider>().start();
    });
  }

  void _showExerciseDialog(BuildContext context, LessonModel lesson) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.fitness_center_rounded,
                color: Colors.deepPurple,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  lesson.tituloAula,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.description,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Recompensa: +${lesson.xpReward} XP',
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseEngineView(lesson: lesson),
                    ),
                  );
                },
                child: const Text(
                  'COMEÇAR AULA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final lessonProvider = context.watch<LessonProvider>();
    final user = authController.userData;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.deepPurple),
        ),
      );
    }

    final level = (user['level'] as num?)?.toInt() ?? 1;
    final streak = (user['streak'] as num?)?.toInt() ?? 0;
    final health = (user['health'] as num?)?.toInt() ?? 5;
    final lessons = <LessonModel>[];
    final lessonUnits = <UnitModel>[];
    for (final unit in lessonProvider.units) {
      for (final lesson in unit.lessons) {
        lessons.add(lesson);
        lessonUnits.add(unit);
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.military_tech_rounded,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Nível $level',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.orangeAccent,
                      size: 22,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$streak',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$health',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: lessonProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          : lessonProvider.errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lessonProvider.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: lessonProvider.refresh,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            )
          : lessons.isEmpty
          ? const Center(child: Text('Nenhuma aula disponível no momento.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                final unit = lessonUnits[index];
                final blocked = !lessonProvider.isLessonUnlocked(unit, lesson);
                final completed = lessonProvider.completedLessonIds.contains(
                  lesson.id,
                );
                final position = switch (index % 4) {
                  1 => 1,
                  3 => -1,
                  _ => 0,
                };
                final alignment = switch (position) {
                  -1 => Alignment.centerLeft,
                  1 => Alignment.centerRight,
                  _ => Alignment.center,
                };

                return Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Align(
                    alignment: alignment,
                    child: MouseRegion(
                      cursor: blocked
                          ? SystemMouseCursors.basic
                          : SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: blocked
                            ? null
                            : () => _showExerciseDialog(context, lesson),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: blocked
                                    ? Colors.grey.shade300
                                    : Colors.orange,
                                border: Border.all(
                                  color: blocked
                                      ? Colors.grey.shade400
                                      : (completed
                                            ? Colors.green.shade700
                                            : Colors.orange.shade800),
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (blocked
                                                ? Colors.grey
                                                : (completed
                                                      ? Colors.green
                                                      : Colors.orange))
                                            .withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                blocked
                                    ? Icons.lock_rounded
                                    : (completed
                                          ? Icons.check_rounded
                                          : Icons.play_arrow_rounded),
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                lesson.tituloAula,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: blocked
                                      ? Colors.grey
                                      : Colors.deepPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
