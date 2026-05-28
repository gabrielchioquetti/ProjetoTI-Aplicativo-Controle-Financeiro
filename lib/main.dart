import 'package:flutter/material.dart';
import 'package:flutter_projeto_ti/screens/cadastro.dart';
import 'package:flutter_projeto_ti/screens/home.dart';
import 'package:flutter_projeto_ti/screens/login.dart';
import 'package:flutter_projeto_ti/screens/nova_transacao.dart';
import 'package:flutter_projeto_ti/screens/perfil.dart';
import 'package:flutter_projeto_ti/screens/transacoes.dart';
import 'package:flutter_projeto_ti/screens/investimentos.dart';

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
        "/transacoes": (context) => TelaTransacoes(),
        "/nova-transacao": (context) => TelaNovaTransacao(),
        "/perfil": (context) => TelaPerfil(),
        "/investimentos": (context) => TelaInvestimentos(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
