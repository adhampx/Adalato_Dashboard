import 'package:adalato_dashboard/pages/navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDeNZxeZIMI0gvezVkIRKK1gBtq3Zn2LEc",
        authDomain: "adalato-3c4bc.firebaseapp.com",
        projectId: "adalato-3c4bc",
        storageBucket: "adalato-3c4bc.appspot.com",
        messagingSenderId: "209540537504",
        appId: "1:209540537504:web:2e41107f2ec3177e78fdc5"),
  );
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: adalato(),
  ));
}

class adalato extends StatelessWidget {
  const adalato({super.key});

  @override
  Widget build(BuildContext context) {
    return const navigation();
  }
}
