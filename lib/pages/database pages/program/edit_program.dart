import 'package:adalato_dashboard/models/program_model.dart';
import 'package:adalato_dashboard/models/workout_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProgramPage extends StatefulWidget {
  final String programId;

  const EditProgramPage({super.key, required this.programId});

  @override
  _EditProgramPageState createState() => _EditProgramPageState();
}

class _EditProgramPageState extends State<EditProgramPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  String _difficultyLevel = 'Beginner';
  double _rating = 0;
  bool _isHidden = false;
  List<String> _selectedWorkouts = [];
  List<String> _selectedTags = [];
  List<WorkoutModel> _workoutList = [];
  final List<String> _tagOptions = [
    'Strength',
    'Cardio',
    'Flexibility',
    'Balance',
    'Endurance'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _durationController = TextEditingController();
    _fetchProgramDetails();
    _fetchWorkouts();
  }

  Future<void> _fetchProgramDetails() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('programs')
        .doc(widget.programId)
        .get();

    ProgramModel program = ProgramModel.fromDocument(doc);
    setState(() {
      _titleController.text = program.title;
      _descriptionController.text = program.description;
      _durationController.text = program.duration.toString();
      _difficultyLevel = program.difficultyLevel;
      _rating = program.rating;
      _isHidden = program.isHidden;
      _selectedWorkouts = program.workoutIds;
      _selectedTags = program.tagIds;
    });
  }

  Future<void> _fetchWorkouts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('workouts').get();
    setState(() {
      _workoutList = querySnapshot.docs
          .map((doc) => WorkoutModel.fromDocument(doc))
          .toList();
    });
  }

  Future<void> _updateProgram() async {
    if (_formKey.currentState!.validate()) {
      String duration = _durationController.text.trim();
      String title = _titleController.text.trim();
      String description = _descriptionController.text.trim();

      ProgramModel updatedProgram = ProgramModel(
        id: widget.programId,
        title: title,
        description: description,
        workoutIds: _selectedWorkouts,
        difficultyLevel: _difficultyLevel,
        duration: int.parse(duration),
        tagIds: _selectedTags,
        rating: _rating,
        favoritesCount: 0, // Update this based on your logic
        isHidden: _isHidden,
      );

      await FirebaseFirestore.instance
          .collection('programs')
          .doc(widget.programId)
          .update(updatedProgram.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Program updated successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Program'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: _difficultyLevel,
                items: ['Beginner', 'Intermediate', 'Advanced']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _difficultyLevel = value.toString();
                  });
                },
                decoration: const InputDecoration(labelText: 'Difficulty Level'),
              ),
              CheckboxListTile(
                title: const Text('Is Hidden'),
                value: _isHidden,
                onChanged: (value) {
                  setState(() {
                    _isHidden = value!;
                  });
                },
              ),
              const Text('Workouts'),
              Wrap(
                children: _workoutList.map((workout) {
                  return ChoiceChip(
                    label: Text(workout.title),
                    selected: _selectedWorkouts.contains(workout.id),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedWorkouts.add(workout.id);
                        } else {
                          _selectedWorkouts.remove(workout.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const Text('Tags'),
              Wrap(
                children: _tagOptions.map((tag) {
                  return FilterChip(
                    label: Text(tag),
                    selected: _selectedTags.contains(tag),
                    onSelected: (selected) {
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProgram,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
