import 'dart:typed_data';

import 'package:adalato_dashboard/models/exercise_model.dart';
import 'package:adalato_dashboard/pages/database%20pages/exercises/exercise_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class EditExercisePage extends StatefulWidget {
  final String exerciseId;

  const EditExercisePage({super.key, required this.exerciseId});

  @override
  _EditExercisePageState createState() => _EditExercisePageState();
}

class _EditExercisePageState extends State<EditExercisePage> {
  final _formKey = GlobalKey<FormState>();
  String exerciseTitle = '';
  String exerciseDescription = '';
  int minutes = 0;
  String difficultyLevel = 'Beginner';
  String muscleGroup = 'Back';
  String equipment = 'other';
  double rating = 0.0;
  int favoritesCount = 0;
  bool isHidden = false;
  String imageUrl = '';
  String videoUrl = '';

  final List<String> difficultyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced'
  ];
  final List<String> muscleGroups = [
    'Back',
    'Biceps',
    'Chest',
    'Triceps',
    'Shoulders',
    'Legs',
    'Abs'
  ];
  final List<String> equipments = [
    'Dip Bar',
    'Parallettes',
    'Barbell',
    'Dumbbell',
    'Pull Up Bar',
    'Other'
  ];

  Uint8List? _imageData;
  Uint8List? _videoData;

  @override
  void initState() {
    super.initState();
    _loadExercise();
  }

  void _loadExercise() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('exercises')
        .doc(widget.exerciseId)
        .get();
    ExerciseModel exercise =
        ExerciseModel.fromMap(doc.data() as Map<String, dynamic>);
    setState(() {
      exerciseTitle = exercise.exerciseTitle;
      exerciseDescription = exercise.exerciseDescription;
      minutes = exercise.minutes;
      difficultyLevel = exercise.difficultyLevel;
      muscleGroup = exercise.muscleGroup;
      equipment = exercise.equipment;
      rating = exercise.rating;
      favoritesCount = exercise.favoritesCount;
      isHidden = exercise.isHidden;
      imageUrl = exercise.imageUrl;
      videoUrl = exercise.videoUrl;
    });
  }

  void uploadFile(
      html.FileUploadInputElement uploadInput, String fileType) async {
    final files = uploadInput.files;
    if (files!.isEmpty) return;

    final reader = html.FileReader();
    reader.readAsArrayBuffer(files[0]);
    reader.onLoadEnd.listen((event) async {
      final fileBytes = reader.result as Uint8List;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('exercises_${fileType}s/${widget.exerciseId}');
      final uploadTask = storageRef.putData(fileBytes);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        if (fileType == 'image') {
          imageUrl = downloadUrl;
          _imageData = fileBytes;
        } else {
          videoUrl = downloadUrl;
          _videoData = fileBytes;
        }
      });
    });
  }

  void handleImageUpload() {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      uploadFile(uploadInput, 'image');
    });
  }

  void handleVideoUpload() {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'video/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      uploadFile(uploadInput, 'video');
    });
  }

  void saveExercise() {
    if (_formKey.currentState!.validate()) {
      final updatedExercise = ExerciseModel(
        id: widget.exerciseId,
        exerciseTitle: exerciseTitle,
        exerciseDescription: exerciseDescription,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
        minutes: minutes,
        difficultyLevel: difficultyLevel,
        muscleGroup: muscleGroup,
        equipment: equipment,
        rating: rating,
        favoritesCount: favoritesCount,
        isHidden: isHidden,
        tagIds: [difficultyLevel, muscleGroup, equipment],
      );

      FirebaseFirestore.instance
          .collection('exercises')
          .doc(widget.exerciseId)
          .update(updatedExercise.toMap())
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercise updated successfully')),
        );
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ExerciseListPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Exercise')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: exerciseTitle,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    exerciseTitle = value;
                  });
                },
              ),
              TextFormField(
                initialValue: exerciseDescription,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    exerciseDescription = value;
                  });
                },
              ),
              TextFormField(
                initialValue: minutes.toString(),
                decoration: const InputDecoration(labelText: 'Minutes'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of minutes';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    minutes = int.parse(value);
                  });
                },
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: difficultyLevel,
                items: difficultyLevels.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    difficultyLevel = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Difficulty Level'),
              ),
              DropdownButtonFormField<String>(
                value: muscleGroup,
                items: muscleGroups.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    muscleGroup = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Muscle Group'),
              ),
              DropdownButtonFormField<String>(
                value: equipment,
                items: equipments.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    equipment = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Equipment'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleImageUpload,
                child: const Text('Upload Image'),
              ),
              _imageData != null
                  ? Image.memory(_imageData!)
                  : (imageUrl.isNotEmpty
                      ? Image.network(imageUrl)
                      : Container()),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleVideoUpload,
                child: const Text('Upload Video'),
              ),
              _videoData != null
                  ? const Text('Video Selected')
                  : (videoUrl.isNotEmpty
                      ? Text('Video URL: $videoUrl')
                      : Container()),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveExercise,
                child: const Text('Save Exercise'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
