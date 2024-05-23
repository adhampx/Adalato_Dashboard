import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int male = 0;
 int Female = 0 ;
  void fetchData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();

    int newMaleCount = 0;
    int newFemaleCount = 0;

    for (var doc in snapshot.docs) {
      if (doc['gender'] == 'Male') {
        newMaleCount++;
      } else if (doc['gender'] == 'Female') {
        newFemaleCount++;
      }
    }

    setState(() {
      male = newMaleCount;
      Female = newFemaleCount;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Adalato Dashboard",style: TextStyle(fontSize: 30, color: Colors.indigo,fontWeight: FontWeight.bold),),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {


            // added a print statement here to show that the snapshot is not from 'stream1' but 'stream2' and vice versa.
            if (snapshot.hasError) {
              return const Center(
                child: Text('error'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                const SizedBox(height: 30,),
                Row(

                  children: [
                    const SizedBox(width: 50,),
            Container(
              width: 300,
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
            gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.blueGrey], // Example gradient colors
            ),
            borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Icon(Icons.login, size: 40, color: Colors.white), // Sign-in icon
            SizedBox(width: 10),
            Text(
            'Signed In',
            style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            ),
            ),
            ],
            ),
            const SizedBox(height: 10),
            Text(
            '${snapshot.data!.docs.length}', // Display the number of signed-in users
            style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            ),
            ),
            ],
            ),
            ),
                    const SizedBox(width: 40,),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.indigo, Colors.blueGrey], // Example gradient colors
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.male, size: 40, color: Colors.white), // Sign-in icon
                              SizedBox(width: 10),
                              Text(
                                'Male',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '$male', // Display the number of signed-in users
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40,),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.red, Colors.blueGrey], // Example gradient colors
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.female, size: 40, color: Colors.white), // Sign-in icon
                              SizedBox(width: 10),
                              Text(
                                'Female',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '$Female', // Display the number of signed-in users
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Row(

                    children: [
                      Expanded(
                        child: Column(
                          children: [


                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Text("Users",style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold,fontSize: 20),),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {


                                    return Card(
                                      child: ListTile(
                                        leading: const Icon(Icons.person, color: Colors.black,),
                                        title:
                                        Text(snapshot.data!.docs[index]['name'].toString()),
                                        subtitle: Text(snapshot.data!.docs[index]['level'].toString() , style: const TextStyle(color: Colors.red),),
                                        trailing:  snapshot.data!.docs[index]['gender'] == "Male" ? const Icon(Icons.male ,color: Colors.blue,):const Icon(Icons.female , color: Colors.red),
                                      ),
                                    );

                                  // ignore: prefer_const_constructors

                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox( height:500, width:500,
                        child: GenderPieChart(maleCount: male, femaleCount: Female,),),
                    ],
                  ),
                ),

              ],
            );

            // return Center(
            //   child: CircularProgressIndicator(),
            // );
          }),
    );
  }
}



class GenderPieChart extends StatelessWidget {
  final int maleCount;
  final int femaleCount;

  const GenderPieChart({super.key, required this.maleCount, required this.femaleCount});

  @override
  Widget build(BuildContext context) {
    final List<GenderData> chartData = [
      GenderData('Male', maleCount),
      GenderData('Female', femaleCount),
    ];

    return SfCircularChart(

      legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      series: <CircularSeries>[
        PieSeries<GenderData, String>(
          dataSource: chartData,
          xValueMapper: (GenderData data, _) => data.gender,
          yValueMapper: (GenderData data, _) => data.count,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
    );
  }
}

class GenderData {
  final String gender;
  final int count;

  GenderData(this.gender, this.count);
}
