import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screen/Sala_escolha_screen.dart';  // Importe a tela de escolha de salas

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RoomSelectionScreen(),  // Tela inicial de escolha de salas
    );
  }
}
