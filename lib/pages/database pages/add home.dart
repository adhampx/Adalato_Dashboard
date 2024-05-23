import 'package:adalato_dashboard/pages/database%20pages/exercises/exercise_list.dart';
import 'package:adalato_dashboard/pages/database%20pages/program/program_list.dart';
import 'package:adalato_dashboard/pages/database%20pages/shop/shop_list.dart';
import 'package:adalato_dashboard/pages/database%20pages/tags/tag_list.dart';
import 'package:adalato_dashboard/pages/database%20pages/tips/tip_list.dart';
import 'package:adalato_dashboard/pages/database%20pages/workout/workout_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildContainer(
              context,
              'Programs',
              Icons.fitness_center,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProgramList()),
              ),
            ),
            _buildContainer(
              context,
              'Workouts',
              Icons.directions_run,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WorkoutListPage()),
              ),
            ),
            _buildContainer(
              context,
              'Exercises',
              Icons.accessibility_new,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExerciseListPage()),
              ),
            ),
            _buildContainer(
              context,
              'Tags',
              Icons.label,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TagListPage()),
              ),
            ),
            _buildContainer(
              context,
              'Shop',
              Icons.shopping_cart,
              Colors.red,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShopItemList()),
              ),
            ),
            _buildContainer(
              context,
              'Tips',
              Icons.lightbulb_outline,
              Colors.teal,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TipListPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
