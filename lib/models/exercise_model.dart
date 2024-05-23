import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseModel {
  String id;
  String exerciseTitle;
  String exerciseDescription;
  String imageUrl;
  String videoUrl;
  int minutes;
  String difficultyLevel; // Beginner, Intermediate, Advanced
  String muscleGroup; // Back, Biceps, Chest, Triceps, Shoulders, Legs, Abs
  String
      equipment; // Dip Bar, Parallettes, Barbell, Dumbbell, Pull Up Bar, Other
  int? repetitions; // Nullable, user-specific
  double? weight; // Nullable, user-specific
  List<String> tagIds; // List of Tag IDs
  double rating;
  bool isHidden;

  int favoritesCount;

  ExerciseModel({
    required this.id,
    required this.exerciseTitle,
    required this.exerciseDescription,
    required this.imageUrl,
    required this.videoUrl,
    required this.minutes,
    required this.difficultyLevel,
    required this.muscleGroup,
    required this.equipment,
    this.repetitions,
    this.weight,
    required this.tagIds,
    required this.rating,
    required this.favoritesCount,
    required this.isHidden,
  });

  // Convert an ExerciseModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseTitle': exerciseTitle,
      'exerciseDescription': exerciseDescription,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'minutes': minutes,
      'difficultyLevel': difficultyLevel,
      'muscleGroup': muscleGroup,
      'equipment': equipment,
      'repetitions': repetitions,
      'weight': weight,
      'tagIds': tagIds,
      'rating': rating,
      'favoritesCount': favoritesCount,
      'isHidden': isHidden,
    };
  }

  // Create an ExerciseModel instance from a map
  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      id: map['id'] ?? '',
      exerciseTitle: map['exerciseTitle'] ?? '',
      exerciseDescription: map['exerciseDescription'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      minutes: map['minutes'] ?? 0,
      difficultyLevel: map['difficultyLevel'] ?? '',
      muscleGroup: map['muscleGroup'] ?? '',
      equipment: map['equipment'] ?? '',
      repetitions: map['repetitions'],
      weight: map['weight']?.toDouble(),
      tagIds: List<String>.from(map['tagIds'] ?? []),
      rating: map['rating']?.toDouble() ?? 0.0,
      favoritesCount: map['favoritesCount'] ?? 0,
      isHidden: map['isHidden'] ?? false,
    );
  }

  // Convert a Firestore document snapshot to an ExerciseModel instance
  factory ExerciseModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExerciseModel.fromMap(data);
  }

  // Convert an ExerciseModel instance to a Firestore document snapshot
  Map<String, dynamic> toDocument() {
    return toMap();
  }
}
