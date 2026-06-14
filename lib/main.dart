import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_projeto_ti/screens/editar_transacao.dart';

import 'firebase_options.dart';

import 'package:flutter_projeto_ti/screens/cadastro.dart';
import 'package:flutter_projeto_ti/screens/home.dart';
import 'package:flutter_projeto_ti/screens/login.dart';
import 'package:flutter_projeto_ti/screens/nova_transacao.dart';
import 'package:flutter_projeto_ti/screens/perfil.dart';
import 'package:flutter_projeto_ti/screens/transacoes.dart';
import 'package:flutter_projeto_ti/screens/investimentos.dart';
import 'package:flutter_projeto_ti/screens/simulador_investimentos.dart';
import 'package:flutter_projeto_ti/screens/resultado_simulacao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle Financeiro',

      // CONFIGURAÇÃO DE LOCALIZAÇÃO (PORTUGUÊS)
      locale: Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Português do Brasil
        Locale('en', 'US'), // Inglês (fallback)
      ],

      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),

      initialRoute: "/",
      routes: {
        "/": (context) => TelaLogin(),
        "/cadastro": (context) => TelaCadastro(),
        "/home": (context) => TelaHome(),
        "/transacoes": (context) => TelaTransacoes(),
        "/nova-transacao": (context) => TelaNovaTransacao(),
        '/editar-transacao': (context) => TelaEditarTransacao(),
        "/perfil": (context) => TelaPerfil(),
        "/investimentos": (context) => TelaInvestimentos(),
        "/simulador-investimentos": (context) => TelaSimuladorInvestimentos(),
        "/resultado-simulacao": (context) => TelaResultadoSimulacao(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
