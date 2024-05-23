import 'package:adalato_dashboard/models/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'edit_exercise.dart';
import 'exercises.dart';

class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({super.key});

  @override
  _ExerciseListPageState createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  final CollectionReference _exercisesCollection =
      FirebaseFirestore.instance.collection('exercises');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise List')),
      body: StreamBuilder(
        stream: _exercisesCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No exercises found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              ExerciseModel exercise = ExerciseModel.fromMap(
                  document.data() as Map<String, dynamic>);
              return Card(
                child: ListTile(
                  title: Text(exercise.exerciseTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ${exercise.exerciseDescription}'),
                      Text('Minutes: ${exercise.minutes}'),
                      Text('Difficulty: ${exercise.difficultyLevel}'),
                      Text('Muscle Group: ${exercise.muscleGroup}'),
                      Text('Equipment: ${exercise.equipment}'),
                      Text('Rating: ${exercise.rating}'),
                      Text('Favorites Count: ${exercise.favoritesCount}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditExercisePage(exerciseId: exercise.id),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _exercisesCollection.doc(exercise.id).delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExercisePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
