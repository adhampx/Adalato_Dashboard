import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  String name;
  String email;
  double weight;
  double height;
  String gender;

  String fitnessLevel; // Beginner, Intermediate, Advanced
  List<String> goals; // Build Muscle, Lose Fat, Learn Techniques
  DateTime subscriptionDate;
  DateTime subscriptionExpiryDate;
  String imageUrl; // URL for the user's profile image
  List<String> favoriteExerciseIds; // List of favorite exercise IDs
  List<String> favoriteWorkoutIds; // List of favorite workout IDs
  List<String> favoriteProgramIds; // List of favorite program IDs

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.weight,
    required this.height,
    required this.gender,
    required this.fitnessLevel,
    required this.goals,
    required this.subscriptionDate,
    required this.subscriptionExpiryDate,
    required this.imageUrl,
    required this.favoriteExerciseIds,
    required this.favoriteWorkoutIds,
    required this.favoriteProgramIds,
  });

  // Convert a UserModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'weight': weight,
      'height': height,
      'gender': gender,
      'fitnessLevel': fitnessLevel,
      'goals': goals,
      'subscriptionDate': subscriptionDate.toIso8601String(),
      'subscriptionExpiryDate': subscriptionExpiryDate.toIso8601String(),
      'imageUrl': imageUrl,
      'favoriteExerciseIds': favoriteExerciseIds,
      'favoriteWorkoutIds': favoriteWorkoutIds,
      'favoriteProgramIds': favoriteProgramIds,
    };
  }

  // Create a UserModel instance from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      weight: map['weight']?.toDouble() ?? 0.0,
      height: map['height']?.toDouble() ?? 0.0,
      fitnessLevel: map['fitnessLevel'] ?? '',
      gender: map['gender'] ?? '',
      goals: List<String>.from(map['goals'] ?? []),
      subscriptionDate: DateTime.parse(
          map['subscriptionDate'] ?? DateTime.now().toIso8601String()),
      subscriptionExpiryDate: DateTime.parse(
          map['subscriptionExpiryDate'] ?? DateTime.now().toIso8601String()),
      imageUrl: map['imageUrl'] ?? '',
      favoriteExerciseIds: List<String>.from(map['favoriteExerciseIds'] ?? []),
      favoriteWorkoutIds: List<String>.from(map['favoriteWorkoutIds'] ?? []),
      favoriteProgramIds: List<String>.from(map['favoriteProgramIds'] ?? []),
    );
  }

  // Convert a Firestore document snapshot to a UserModel instance
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  // Convert a UserModel instance to a Firestore document snapshot
  Map<String, dynamic> toDocument() {
    return toMap();
  }
}
