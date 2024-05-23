import 'package:adalato_dashboard/models/workout_model.dart';
import 'package:adalato_dashboard/pages/database%20pages/workout/edit_workout.dart';
import 'package:adalato_dashboard/pages/database%20pages/workout/workout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class WorkoutListPage extends StatefulWidget {
  const WorkoutListPage({super.key});

  @override
  _WorkoutListPageState createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('workouts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LinearProgressIndicator();
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return _buildWorkoutCard(context, doc);
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWorkoutPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWorkoutCard(BuildContext context, DocumentSnapshot doc) {
    final workout = WorkoutModel.fromMap(doc.data() as Map<String, dynamic>);
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(workout.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${workout.description}'),
            Text('Duration: ${workout.duration} minutes'),
            Text('Difficulty Level: ${workout.difficultyLevel}'),
            Text('Rating: ${workout.rating}'),
            Text('Favorites Count: ${workout.favoritesCount}'),
            _buildExerciseList(workout.exerciseIds),
            Text('Tags: ${workout.tagIds.join(', ')}'),
            Text('Hidden: ${workout.isHidden ? 'Yes' : 'No'}'),
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
                    builder: (context) => EditWorkoutPage(workout: workout),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteWorkout(doc.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList(List<String> exerciseIds) {
    if (exerciseIds.isEmpty) {
      return const Text('No exercises linked.');
    }
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _fetchExercises(exerciseIds),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: snapshot.data!.map((exerciseDoc) {
            final exerciseData = exerciseDoc.data() as Map<String, dynamic>;
            return Text('Exercise: ${exerciseData['exerciseTitle']}');
          }).toList(),
        );
      },
    );
  }

  Future<List<DocumentSnapshot>> _fetchExercises(
      List<String> exerciseIds) async {
    final List<Future<DocumentSnapshot>> futures = exerciseIds.map((id) {
      return FirebaseFirestore.instance.collection('exercises').doc(id).get();
    }).toList();
    return Future.wait(futures);
  }

  void _deleteWorkout(String id) {
    FirebaseFirestore.instance.collection('workouts').doc(id).delete();
  }
}
