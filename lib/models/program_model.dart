import 'package:cloud_firestore/cloud_firestore.dart';

class ProgramModel {
  String id;
  String title;
  String description;
  List<String> workoutIds; // List of Workout IDs
  String difficultyLevel; // Beginner, Intermediate, Advanced
  int duration; // Total duration in minutes
  List<String> tagIds; // List of Tag IDs
  double rating;
  bool isHidden;

  int favoritesCount;

  ProgramModel({
    required this.id,
    required this.title,
    required this.description,
    required this.workoutIds,
    required this.difficultyLevel,
    required this.duration,
    required this.tagIds,
    required this.rating,
    required this.favoritesCount,
    required this.isHidden,
  });

  // Convert a ProgramModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'workoutIds': workoutIds,
      'difficultyLevel': difficultyLevel,
      'duration': duration,
      'tagIds': tagIds,
      'rating': rating,
      'favoritesCount': favoritesCount,
      'isHidden': isHidden,
    };
  }

  // Create a ProgramModel instance from a map
  factory ProgramModel.fromMap(Map<String, dynamic> map) {
    return ProgramModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      workoutIds: List<String>.from(map['workoutIds'] ?? []),
      difficultyLevel: map['difficultyLevel'] ?? '',
      duration: map['duration'] ?? 0,
      tagIds: List<String>.from(map['tagIds'] ?? []),
      rating: map['rating']?.toDouble() ?? 0.0,
      favoritesCount: map['favoritesCount'] ?? 0,
      isHidden: map['isHidden'] ?? false,
    );
  }

  // Convert a Firestore document snapshot to a ProgramModel instance
  factory ProgramModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProgramModel.fromMap(data);
  }

  // Convert a ProgramModel instance to a Firestore document snapshot
  Map<String, dynamic> toDocument() {
    return toMap();
  }
}
