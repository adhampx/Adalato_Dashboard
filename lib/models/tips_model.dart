import 'package:cloud_firestore/cloud_firestore.dart';

class TipModel {
  String tipId;
  String title;
  String description;

  TipModel({
    required this.tipId,
    required this.title,
    required this.description,
  });

  // Convert a TipModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'tipId': tipId,
      'title': title,
      'description': description,
    };
  }

  // Create a TipModel instance from a map
  factory TipModel.fromMap(Map<String, dynamic> map) {
    return TipModel(
      tipId: map['tipId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }

  // Convert a Firestore document snapshot to a TipModel instance
  factory TipModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TipModel.fromMap(data);
  }

  // Convert a TipModel instance to a Firestore document snapshot
  Map<String, dynamic> toDocument() {
    return toMap();
  }
}
