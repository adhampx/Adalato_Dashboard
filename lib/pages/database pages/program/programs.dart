import 'package:adalato_dashboard/models/program_model.dart';
import 'package:adalato_dashboard/models/workout_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProgramForm extends StatefulWidget {
  const ProgramForm({super.key});

  @override
  _ProgramFormState createState() => _ProgramFormState();
}

class _ProgramFormState extends State<ProgramForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  int _duration = 0;
  String _difficultyLevel = 'Beginner';
  final List<String> _workoutIds = [];
  final List<String> _selectedTags = [];
  final double _rating = 0.0;
  bool _isHidden = false;
  List<WorkoutModel> _workouts = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkouts();
  }

  Future<void> _fetchWorkouts() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('workouts').get();
    final workouts =
        snapshot.docs.map((doc) => WorkoutModel.fromMap(doc.data())).toList();
    setState(() {
      _workouts = workouts;
    });
  }

  Future<void> _saveProgram() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final id = const Uuid().v4();
      final newProgram = ProgramModel(
        id: id,
        title: _title,
        description: _description,
        workoutIds: _workoutIds,
        difficultyLevel: _difficultyLevel,
        duration: _duration,
        tagIds: _selectedTags,
        rating: _rating,
        favoritesCount: 0,
        isHidden: _isHidden,
      ).toMap();

      await FirebaseFirestore.instance
          .collection('programs')
          .doc(id)
          .set(newProgram);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Program saved successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Program')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Duration (minutes)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a duration';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _duration = int.parse(value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _difficultyLevel,
                        decoration: const InputDecoration(
                          labelText: 'Difficulty Level',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Beginner', 'Intermediate', 'Advanced']
                            .map((String level) {
                          return DropdownMenuItem<String>(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _difficultyLevel = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Workouts',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      ..._workouts.map((workout) {
                        return CheckboxListTile(
                          title: Text(workout.title),
                          value: _workoutIds.contains(workout.id),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _workoutIds.add(workout.id);
                              } else {
                                _workoutIds.remove(workout.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                      const Text('Tags',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: [
                          'Strength',
                          'Cardio',
                          'Flexibility',
                          'Balance',
                          'Endurance'
                        ].map((String tag) {
                          return FilterChip(
                            label: Text(tag),
                            selected: _selectedTags.contains(tag),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _selectedTags.add(tag);
                                } else {
                                  _selectedTags.remove(tag);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      SwitchListTile(
                        title: const Text('Is Hidden'),
                        value: _isHidden,
                        onChanged: (bool value) {
                          setState(() {
                            _isHidden = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveProgram,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(width: 8),
                            Text('Save Program'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
