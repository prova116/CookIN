//import 'package:cookin/view/on_boarding/startup_view.dart';
//import 'package:cookin/view/login/welcome_view.dart';
import 'package:cookin/view/on_boarding/startup_view.dart/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "metropolis",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //useMaterial3: true,
      ),
      home: const StartupView(),
    );
  }
}
