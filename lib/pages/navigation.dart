import 'package:adalato_dashboard/pages/analysis/analysis_screen.dart';
import 'package:adalato_dashboard/pages/database%20pages/add%20home.dart';
import 'package:adalato_dashboard/pages/home.dart';
import 'package:flutter/material.dart';

class navigation extends StatefulWidget {
  const navigation({super.key});

  @override
  _navigationState createState() => _navigationState();
}

class _navigationState extends State<navigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const home(),
    const AnalysisScreen(),
    const HomeScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 80,
            color: Colors.indigo[900],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.home,
                      color:
                          _selectedIndex == 0 ? Colors.white : Colors.white54),
                  iconSize: 30,
                  onPressed: () {
                    _onItemTapped(0);
                  },
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.bar_chart,
                      color:
                          _selectedIndex == 1 ? Colors.white : Colors.white54),
                  iconSize: 30,
                  onPressed: () {
                    _onItemTapped(1);
                  },
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.file_copy_rounded,
                      color:
                          _selectedIndex == 2 ? Colors.white : Colors.white54),
                  iconSize: 30,
                  onPressed: () {
                    _onItemTapped(2);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
