import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voxify/data/repositories/lesson_repository.dart';
import 'package:voxify/models/exercise_model.dart';
import 'package:voxify/models/unit_model.dart';

class LessonProvider extends ChangeNotifier {
  final LessonRepository _repository;
  final FirebaseAuth _auth;

  LessonProvider({LessonRepository? repository, FirebaseAuth? auth})
    : _repository = repository ?? LessonRepository(),
      _auth = auth ?? FirebaseAuth.instance;

  final Map<String, List<LessonModel>> _lessonsByUnit = {};
  final Map<String, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
  _lessonSubscriptions = {};
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _unitsSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSubscription;
  List<UnitModel> _units = [];
  Set<String> _completedLessonIds = {};
  Set<String> _unlockedUnitIds = {'unit_1'};
  int _health = 5;
  bool _isLoading = false;
  String? _errorMessage;
  String? _uid;

  List<UnitModel> get units => _units;
  Set<String> get completedLessonIds => Set.unmodifiable(_completedLessonIds);
  int get health => _health;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> start() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      _errorMessage = 'Faça login para carregar suas aulas.';
      _isLoading = false;
      notifyListeners();
      return;
    }
    if (_uid == uid && _unitsSubscription != null) return;

    await _cancelSubscriptions();
    _uid = uid;
    _isLoading = true;
    _errorMessage = null;
    _units = [];
    _lessonsByUnit.clear();
    notifyListeners();

    try {
      await _repository.ensureDefaultUnit();
      _userSubscription = _repository
          .watchUser(uid)
          .listen(
            (snapshot) {
              final data = snapshot.data();
              _completedLessonIds = Set<String>.from(
                data?['completedLessonIds'] as List? ?? [],
              );
              final progress = Map<String, dynamic>.from(
                data?['lessonProgress'] as Map? ?? {},
              );
              _completedLessonIds.addAll(
                progress.entries
                    .where(
                      (entry) => (entry.value as Map?)?['concluido'] == true,
                    )
                    .map((entry) => entry.key),
              );
              _unlockedUnitIds = Set<String>.from(
                data?['unlockedUnitIds'] as List? ?? ['unit_1'],
              );
              _health = (data?['health'] as num?)?.toInt() ?? 5;
              notifyListeners();
            },
            onError: (Object error) {
              _setError('Não foi possível carregar seu progresso: $error');
            },
          );
      _unitsSubscription = _repository.watchUnits().listen(
        _onUnitsChanged,
        onError: (Object error) {
          _setError('Não foi possível carregar as unidades: $error');
        },
      );
    } catch (error) {
      _setError('Não foi possível preparar as aulas: $error');
    }
  }

  Future<void> refresh() async {
    await _cancelSubscriptions();
    _uid = null;
    await start();
  }

  bool isLessonUnlocked(UnitModel unit, LessonModel lesson) {
    final index = unit.lessons.indexWhere((item) => item.id == lesson.id);
    final unitUnlocked =
        unit.id == 'unit_1' || _unlockedUnitIds.contains(unit.id);
    return unitUnlocked &&
        (index == 0 ||
            (index > 0 &&
                _completedLessonIds.contains(unit.lessons[index - 1].id)));
  }

  Future<bool> completeLesson(
    LessonModel lesson, {
    required double score,
  }) async {
    final uid = _uid;
    if (uid == null) throw StateError('Usuário não autenticado.');

    final unit = _units.firstWhere(
      (item) => item.id == lesson.unitId,
      orElse: () => throw StateError('Unidade da aula não encontrada.'),
    );
    if (!isLessonUnlocked(unit, lesson)) {
      throw StateError('Conclua a aula anterior antes de continuar.');
    }

    final completed = await _repository.completeLesson(
      uid: uid,
      unit: unit,
      lesson: lesson,
      score: score,
    );
    if (completed) {
      _completedLessonIds = {..._completedLessonIds, lesson.id};
      notifyListeners();
    }
    return completed;
  }

  Future<int> consumeLife() async {
    final uid = _uid;
    if (uid == null) throw StateError('Usuário não autenticado.');
    _health = await _repository.consumeLife(uid);
    notifyListeners();
    return _health;
  }

  void _onUnitsChanged(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final unitIds = snapshot.docs.map((doc) => doc.id).toSet();
    for (final id in _lessonSubscriptions.keys.toList()) {
      if (!unitIds.contains(id)) {
        _lessonSubscriptions.remove(id)?.cancel();
        _lessonsByUnit.remove(id);
      }
    }

    _units = snapshot.docs
        .map((doc) => UnitModel.fromMap(doc.id, doc.data()))
        .toList();
    for (final doc in snapshot.docs) {
      if (!_lessonSubscriptions.containsKey(doc.id)) {
        _lessonSubscriptions[doc.id] = _repository
            .watchLessons(doc.id)
            .listen(
              (lessonSnapshot) {
                _lessonsByUnit[doc.id] = lessonSnapshot.docs
                    .map(
                      (lessonDoc) => LessonModel.fromMap(
                        lessonDoc.data(),
                        id: lessonDoc.id,
                        unitId: doc.id,
                      ),
                    )
                    .toList();
                _updateUnits();
              },
              onError: (Object error) {
                _setError(
                  'Não foi possível carregar as aulas da unidade: $error',
                );
              },
            );
      }
    }
    _updateUnits();
  }

  void _updateUnits() {
    _units = _units
        .map(
          (unit) => unit.copyWith(lessons: _lessonsByUnit[unit.id] ?? const []),
        )
        .toList();
    _isLoading = _units.any((unit) => !_lessonsByUnit.containsKey(unit.id));
    if (!_isLoading) _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _isLoading = false;
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> _cancelSubscriptions() async {
    await _unitsSubscription?.cancel();
    await _userSubscription?.cancel();
    for (final subscription in _lessonSubscriptions.values) {
      await subscription.cancel();
    }
    _unitsSubscription = null;
    _userSubscription = null;
    _lessonSubscriptions.clear();
  }

  @override
  void dispose() {
    _unitsSubscription?.cancel();
    _userSubscription?.cancel();
    for (final subscription in _lessonSubscriptions.values) {
      subscription.cancel();
    }
    super.dispose();
  }
}
