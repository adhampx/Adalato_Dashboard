import 'package:cloud_firestore/cloud_firestore.dart';

class TagModel {
  String tagId;
  String name;

  TagModel({
    required this.tagId,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'tagId': tagId,
      'name': name,
    };
  }

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      tagId: map['tagId'] ?? '',
      name: map['name'] ?? '',
    );
  }

  factory TagModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TagModel.fromMap(data);
  }
}
