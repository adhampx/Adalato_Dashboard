import 'package:adalato_dashboard/models/program_model.dart';
import 'package:adalato_dashboard/pages/database%20pages/program/edit_program.dart';
import 'package:adalato_dashboard/pages/database%20pages/program/programs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProgramList extends StatelessWidget {
  const ProgramList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('programs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final programs = snapshot.data!.docs
              .map((doc) =>
                  ProgramModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          return ListView.builder(
            itemCount: programs.length,
            itemBuilder: (context, index) {
              final program = programs[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(program.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text('Description: ${program.description}'),
                      const SizedBox(height: 10),
                      Text('Duration: ${program.duration} minutes'),
                      const SizedBox(height: 10),
                      Text('Difficulty Level: ${program.difficultyLevel}'),
                      const SizedBox(height: 10),
                      Text('Rating: ${program.rating}'),
                      const SizedBox(height: 10),
                      Text('Favorites Count: ${program.favoritesCount}'),
                      const SizedBox(height: 10),
                      const Text('Workouts:'),
                      for (var workoutId in program.workoutIds)
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('workouts')
                              .doc(workoutId)
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox();
                            }
                            final workoutData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Text('- ${workoutData['title']}');
                          },
                        ),
                      const SizedBox(height: 10),
                      Text('Tags: ${program.tagIds.join(', ')}'),
                      const SizedBox(height: 10),
                      Text(
                          'Visibility: ${program.isHidden ? "Hidden" : "Visible"}'),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProgramPage(programId: program.id),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('programs')
                                  .doc(program.id)
                                  .delete();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProgramForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
