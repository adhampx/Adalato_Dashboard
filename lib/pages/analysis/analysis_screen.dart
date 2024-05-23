import 'package:adalato_dashboard/pages/analysis/level.dart';
import 'package:adalato_dashboard/pages/analysis/level_bygender.dart';
import 'package:adalato_dashboard/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int male = 0;

  int Female = 0;
  int begin = 0;
  int inter = 0;
  int advance = 0;
  int mbeg = 0;
  int mint = 0;
  int mad = 0;
  int fbeg = 0;
  int fint = 0;
  int fad = 0;

  void _fetchData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    int newMaleCount = 0;
    int newFemaleCount = 0;
    int maleBeginnerCount = 0;
    int maleIntermediateCount = 0;
    int maleAdvancedCount = 0;
    int femaleBeginnerCount = 0;
    int femaleIntermediateCount = 0;
    int femaleAdvancedCount = 0;

    int newbegin = 0;
    int newinter = 0;
    int newadvance = 0;
    for (var doc in snapshot.docs) {
      if (doc['gender'] == 'Male') {
        newMaleCount++;
      } else if (doc['gender'] == 'Female') {
        newFemaleCount++;
      }
    }
    for (var doc in snapshot.docs) {
      if (doc['level'] == 'Beginner') {
        newbegin++;
      } else if (doc['level'] == 'Intermediate') {
        newinter++;
      } else if (doc['level'] == 'Advanced') {
        newadvance++;
      }
    }
    for (var doc in snapshot.docs) {
      if (doc['level'] == 'Beginner' && doc['gender'] == 'Male') {
        maleBeginnerCount++;
      }
      if (doc['level'] == 'Intermediate' && doc['gender'] == 'Male') {
        maleIntermediateCount++;
      }
      if (doc['level'] == 'Advanced' && doc['gender'] == 'Male') {
        maleAdvancedCount++;
      }
    }
    for (var doc in snapshot.docs) {
      if (doc['level'] == 'Beginner' && doc['gender'] == 'Female') {
        femaleBeginnerCount++;
      }
      if (doc['level'] == 'Intermediate' && doc['gender'] == 'Female') {
        femaleIntermediateCount++;
      }
      if (doc['level'] == 'Advanced' && doc['gender'] == 'Female') {
        femaleAdvancedCount++;
      }
    }

    setState(() {
      fbeg = femaleBeginnerCount;
      fint = femaleIntermediateCount;
      fad = femaleAdvancedCount;
      begin = newbegin;
      inter = newinter;
      mbeg = maleBeginnerCount;
      mint = maleIntermediateCount;
      mad = maleAdvancedCount;
      advance = newadvance;
      male = newMaleCount;
      Female = newFemaleCount;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Analysis Dashboard",
          style: TextStyle(
              fontSize: 30, color: Colors.indigo, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: StrengthLevelByGenderChart(
                    maleBeginnerCount: mbeg,
                    maleIntermediateCount: mint,
                    maleAdvancedCount: mad,
                    femaleBeginnerCount: fbeg,
                    femaleIntermediateCount: fint,
                    femaleAdvancedCount: fad,
                  ),
                ),
                Expanded(
                    child: StrengthLevelBarChart(
                  beginnerCount: begin,
                  intermediateCount: inter,
                  advancedCount: advance,
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: GenderPieChart(
                  maleCount: male,
                  femaleCount: Female,
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
