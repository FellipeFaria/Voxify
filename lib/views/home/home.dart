import 'package:flutter/material.dart';
import 'package:voxify/data/mock/mock_lessons_data.dart';
import 'package:voxify/models/exercise_model.dart';
import 'package:voxify/views/exercises/exercise_engine_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  // dados mock para teste
  final int _nivelAtual = 2;
  final int _diasSequencia = 4;
  final int _vidasRestantes = 5;

  final List<Map<String, dynamic>> _exercises = [
    {
      'id': '1',
      'titulo': 'Vogais e Sons Básicos',
      'descricao':
          'Aqueça sua articulação praticando a pronúncia clara das vogais e emissão de sons abertos.',
      'bloqueado': false,
      'concluido': true,
      'posicao': 0,
    },
    {
      'id': '2',
      'titulo': 'Fonema /R/ Brando',
      'descricao':
          'Treine a vibração da ponta da língua em palavras como "Cora", "Maro" e "Arara".',
      'bloqueado': false,
      'concluido': false,
      'posicao': 1,
    },
    {
      'id': '3',
      'titulo': 'Fonema /L/ Intervocálico',
      'descricao':
          'Pratique o posicionamento correto do topo da língua no céu da boca.',
      'bloqueado': true,
      'concluido': false,
      'posicao': 0,
    },
    {
      'id': '4',
      'titulo': 'Encontros Consonantais /PR/ e /TR/',
      'descricao':
          'Exercícios de agilidade para coordenação de sílabas complexas.',
      'bloqueado': true,
      'concluido': false,
      'posicao': -1,
    },
    {
      'id': '5',
      'titulo': 'Desafio: Trava-Línguas',
      'descricao':
          'Teste sua fluência e clareza pronunciando frases rápidas sem hesitação.',
      'bloqueado': true,
      'concluido': false,
      'posicao': 0,
    },
  ];

  void _showExerciseDialog(
    BuildContext context,
    Map<String, dynamic> exercise,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
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
                  exercise['titulo'],
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
                exercise['titulo'],
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
                    'Recompensa: +50 XP',
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
                  Navigator.pop(ctx);

                  LessonModel lessonSelecionada;
                  if (exercise['id'] == '1') {
                    lessonSelecionada = MockLessonsData.aulaVogais;
                  } else if (exercise['id'] == '2') {
                    lessonSelecionada = MockLessonsData.aulaRBrando;
                  } else {
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ExerciseEngineView(lesson: lessonSelecionada),
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
                      'Nível $_nivelAtual',
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
                      '$_diasSequencia',
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
                      '$_vidasRestantes',
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

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        itemCount: _exercises.length,
        itemBuilder: (context, index) {
          final item = _exercises[index];
          final bool blocked = item['bloqueado'];
          final bool completed = item['concluido'];
          final int position = item['posicao'];

          Alignment alignment = Alignment.center;
          if (position == -1) alignment = Alignment.centerLeft;
          if (position == 1) alignment = Alignment.centerRight;

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
                      : () => _showExerciseDialog(context, item),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: blocked ? Colors.grey.shade300 : Colors.orange,
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
                          item['titulo'],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: blocked ? Colors.grey : Colors.deepPurple,
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
