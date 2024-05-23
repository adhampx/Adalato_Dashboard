import 'package:adalato_dashboard/models/workout_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditWorkoutPage extends StatefulWidget {
  final WorkoutModel workout;

  const EditWorkoutPage({super.key, required this.workout});

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _difficultyLevel;
  late int _duration;
  late double _rating;
  late int _favoritesCount;
  late bool _isHidden;
  List<String> _exerciseIds = [];
  List<String> _tagIds = [];

  @override
  void initState() {
    super.initState();
    _title = widget.workout.title;
    _description = widget.workout.description;
    _difficultyLevel = widget.workout.difficultyLevel;
    _duration = widget.workout.duration;
    _rating = widget.workout.rating;
    _favoritesCount = widget.workout.favoritesCount;
    _isHidden = widget.workout.isHidden;
    _exerciseIds = List.from(widget.workout.exerciseIds);
    _tagIds = List.from(widget.workout.tagIds);
  }

  Future<void> _updateWorkout() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedWorkout = WorkoutModel(
        id: widget.workout.id,
        title: _title,
        description: _description,
        difficultyLevel: _difficultyLevel,
        duration: _duration,
        rating: _rating,
        favoritesCount: _favoritesCount,
        isHidden: _isHidden,
        exerciseIds: _exerciseIds,
        tagIds: _tagIds,
      ).toMap();

      await FirebaseFirestore.instance
          .collection('workouts')
          .doc(widget.workout.id)
          .update(updatedWorkout)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout updated successfully')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update workout: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                initialValue: _duration.toString(),
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter duration';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _duration = int.parse(value!);
                },
              ),
              DropdownButtonFormField<String>(
                value: _difficultyLevel,
                decoration: const InputDecoration(labelText: 'Difficulty Level'),
                items: ['Beginner', 'Intermediate', 'Advanced']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _difficultyLevel = value!;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Is Hidden'),
                value: _isHidden,
                onChanged: (value) {
                  setState(() {
                    _isHidden = value;
                  });
                },
              ),
              FutureBuilder<QuerySnapshot>(
                future:
                    FirebaseFirestore.instance.collection('exercises').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Exercises', style: TextStyle(fontSize: 16)),
                      ...snapshot.data!.docs.map((doc) {
                        final exercise = doc.data() as Map<String, dynamic>;
                        return CheckboxListTile(
                          title: Text(exercise['exerciseTitle']),
                          value: _exerciseIds.contains(doc.id),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _exerciseIds.add(doc.id);
                              } else {
                                _exerciseIds.remove(doc.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('tags').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tags', style: TextStyle(fontSize: 16)),
                      ...snapshot.data!.docs.map((doc) {
                        final tag = doc.data() as Map<String, dynamic>;
                        return CheckboxListTile(
                          title: Text(tag['name']),
                          value: _tagIds.contains(doc.id),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _tagIds.add(doc.id);
                              } else {
                                _tagIds.remove(doc.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: _updateWorkout,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
