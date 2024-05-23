import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutModel {
  String id;
  String title;
  String description;
  List<String> exerciseIds; // List of Exercise IDs
  String difficultyLevel; // Beginner, Intermediate, Advanced
  int duration; // Total duration in minutes
  List<String> tagIds; // List of Tag IDs
  double rating;
  bool isHidden;

  int favoritesCount;

  WorkoutModel({
    required this.id,
    required this.title,
    required this.description,
    required this.exerciseIds,
    required this.difficultyLevel,
    required this.duration,
    required this.tagIds,
    required this.rating,
    required this.favoritesCount,
    required this.isHidden,
  });

  // Convert a WorkoutModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'exerciseIds': exerciseIds,
      'difficultyLevel': difficultyLevel,
      'duration': duration,
      'tagIds': tagIds,
      'rating': rating,
      'favoritesCount': favoritesCount,
      'isHidden': isHidden,
    };
  }

  // Create a WorkoutModel instance from a map
  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      exerciseIds: List<String>.from(map['exerciseIds'] ?? []),
      difficultyLevel: map['difficultyLevel'] ?? '',
      duration: map['duration'] ?? 0,
      tagIds: List<String>.from(map['tagIds'] ?? []),
      rating: map['rating']?.toDouble() ?? 0.0,
      favoritesCount: map['favoritesCount'] ?? 0,
      isHidden: map['isHidden'] ?? false,
    );
  }

  // Convert a Firestore document snapshot to a WorkoutModel instance
  factory WorkoutModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkoutModel.fromMap(data);
  }

  // Convert a WorkoutModel instance to a Firestore document snapshot
  Map<String, dynamic> toDocument() {
    return toMap();
  }
}
