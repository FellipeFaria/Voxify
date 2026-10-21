import 'package:flutter/material.dart';

class AboutPageView extends StatelessWidget {
  const AboutPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Sobre o Voxify',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.deepPurple, width: 3),
                    ),
                    child: const Icon(
                      Icons.record_voice_over_rounded,
                      size: 50,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Voxify',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Versão 1.0.0 (MVP)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            _buildInfoCard(
              title: 'Objetivo do Voxify',
              icon: Icons.track_changes_rounded,
              child: const Text(
                'O Voxify é uma plataforma móvel gamificada criada para auxiliar e acompanhar pacientes em exercícios fonoaudiológicos extraclínicos.'
                ' Através de dinâmicas interativas no estilo "Listen and Repeat" (Escuta e Fala) e reconhecimento vocal, o aplicativo busca aumentar o engajamento e a constância nos treinos diários de articulação e pronúncia de fonemas.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              title: 'Equipe de Desenvolvimento',
              icon: Icons.group_rounded,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BuildMemberTile(
                    name: 'Fellipe Faria',
                    function: 'Desenvolvedor Full-Stack',
                  ),
                  Divider(height: 16),
                  _BuildMemberTile(
                    name: 'Felipe dos Santos Lofrano',
                    function: 'Desenvolvedor Full-Stack',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              title: 'Informações Acadêmicas',
              icon: Icons.school_rounded,
              child: const Column(
                children: [
                  _BuildAcademicRow(
                    label: 'Instituição',
                    value: 'FATEC Ribeirão Preto',
                  ),
                  SizedBox(height: 10),
                  _BuildAcademicRow(
                    label: 'Curso',
                    value: 'Análise e Desenvolvimento de Sistemas',
                  ),
                  SizedBox(height: 10),
                  _BuildAcademicRow(
                    label: 'Disciplina',
                    value: 'Desenvolvimento para Dispositivos Móveis',
                  ),
                  SizedBox(height: 10),
                  _BuildAcademicRow(
                    label: 'Professor',
                    value: 'Prof. Rodrigo de Oliveira Plotze',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Center(
              child: Text(
                '© 2026 Voxify - Todos os direitos reservados',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.deepPurple, size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _BuildMemberTile extends StatelessWidget {
  final String name;
  final String function;

  const _BuildMemberTile({required this.name, required this.function});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.person, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              function,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

class _BuildAcademicRow extends StatelessWidget {
  final String label;
  final String value;

  const _BuildAcademicRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 95,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
