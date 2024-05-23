import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final _formKey = GlobalKey<FormState>();
  String _exerciseTitle = '';
  String _exerciseDescription = '';
  int _minutes = 0;
  String _difficultyLevel = 'Beginner';
  String _muscleGroup = 'Back';
  String _equipment = 'Dip Bar';
  final List<String> _tagIds = [];
  final double _rating = 0.0;
  final int _favoritesCount = 0;
  final bool _isHidden = false;

  html.File? _selectedImage;
  html.File? _selectedVideo;
  String? _imageUrl;
  String? _videoUrl;
  Uint8List? _imageData;
  Uint8List? _videoData;

  void _pickImage() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files?.length == 1) {
        final file = files!.first;
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((e) {
          setState(() {
            _selectedImage = file;
            _imageData = reader.result as Uint8List?;
          });
        });
      }
    });
  }

  void _pickVideo() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..accept = 'video/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files?.length == 1) {
        final file = files!.first;
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((e) {
          setState(() {
            _selectedVideo = file;
            _videoData = reader.result as Uint8List?;
          });
        });
      }
    });
  }

  Future<String> _uploadFile(html.File file, String path) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);

    final completer = Completer<String>();
    reader.onLoadEnd.listen((e) async {
      final data = reader.result as Uint8List;
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(path)
          .child(const Uuid().v4());
      final uploadTask = storageRef.putData(data);

      final snapshot = await uploadTask;
      final fileUrl = await snapshot.ref.getDownloadURL();
      completer.complete(fileUrl);
    });

    return completer.future;
  }

  Future<void> _saveExercise() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (_selectedImage != null) {
        _imageUrl = await _uploadFile(_selectedImage!, 'exercises_images');
      }
      if (_selectedVideo != null) {
        _videoUrl = await _uploadFile(_selectedVideo!, 'exercises_videos');
      }

      final newExercise = {
        'id': const Uuid().v4(),
        'exerciseTitle': _exerciseTitle,
        'exerciseDescription': _exerciseDescription,
        'minutes': _minutes,
        'difficultyLevel': _difficultyLevel,
        'muscleGroup': _muscleGroup,
        'equipment': _equipment,
        'tagIds': [_difficultyLevel, _muscleGroup, _equipment],
        'rating': _rating,
        'favoritesCount': _favoritesCount,
        'isHidden': _isHidden,
        'imageUrl': _imageUrl,
        'videoUrl': _videoUrl,
      };

      await FirebaseFirestore.instance
          .collection('exercises')
          .doc(newExercise['id'] as String)
          .set(newExercise);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Exercise saved successfully')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Exercise Title'),
                onSaved: (value) => _exerciseTitle = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Exercise Description'),
                onSaved: (value) => _exerciseDescription = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Minutes'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _minutes = int.parse(value!),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter duration in minutes' : null,
              ),
              DropdownButtonFormField(
                value: _difficultyLevel,
                items: ['Beginner', 'Intermediate', 'Advanced']
                    .map((String value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _difficultyLevel = newValue as String;
                  });
                },
                onSaved: (value) => _difficultyLevel = value as String,
                decoration: const InputDecoration(labelText: 'Difficulty Level'),
              ),
              DropdownButtonFormField(
                value: _muscleGroup,
                items: [
                  'Back',
                  'Biceps',
                  'Chest',
                  'Triceps',
                  'Shoulders',
                  'Legs',
                  'Abs'
                ].map((String value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _muscleGroup = newValue as String;
                  });
                },
                onSaved: (value) => _muscleGroup = value as String,
                decoration: const InputDecoration(labelText: 'Muscle Group'),
              ),
              DropdownButtonFormField(
                value: _equipment,
                items: [
                  'Dip Bar',
                  'Parallettes',
                  'Barbell',
                  'Dumbbell',
                  'Pull Up Bar',
                  'Other'
                ].map((String value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _equipment = newValue as String;
                  });
                },
                onSaved: (value) => _equipment = value as String,
                decoration: const InputDecoration(labelText: 'Equipment'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
                  ElevatedButton(
                    onPressed: _pickVideo,
                    child: const Text('Pick Video'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_imageData != null) Image.memory(_imageData!),
              if (_videoData != null) VideoPlayerWidget(videoData: _videoData!),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveExercise,
                child: const Text('Save Exercise'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final Uint8List videoData;

  const VideoPlayerWidget({super.key, required this.videoData});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Column(
        children: [
          Text('Video Preview:'),
          // You can integrate a video player package like 'video_player' to display the video.
        ],
      ),
    );
  }
}
