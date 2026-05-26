import 'package:flutter/material.dart';
import 'package:flutter_projeto_ti/screens/cadastro.dart';
import 'package:flutter_projeto_ti/screens/home.dart';
import 'package:flutter_projeto_ti/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => TelaLogin(),
        "/cadastro": (context) => TelaCadastro(),
        "/home": (context) => TelaHome(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
