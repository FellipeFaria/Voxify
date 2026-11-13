import 'package:voxify/models/exercise_model.dart';

class UnitModel {
  final String id;
  final String title;
  final String description;
  final int order;
  final List<LessonModel> lessons;

  const UnitModel({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    this.lessons = const [],
  });

  factory UnitModel.fromMap(
    String id,
    Map<String, dynamic> map, {
    List<LessonModel> lessons = const [],
  }) {
    return UnitModel(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      order: (map['order'] as num?)?.toInt() ?? 0,
      lessons: lessons,
    );
  }

  UnitModel copyWith({List<LessonModel>? lessons}) {
    return UnitModel(
      id: id,
      title: title,
      description: description,
      order: order,
      lessons: lessons ?? this.lessons,
    );
  }
}
