import 'package:flutter/material.dart';

class TelaUsuario extends StatefulWidget{
  @override
  State<TelaUsuario> createState() => _TelaUsuario();
}

class _TelaUsuario extends State<TelaUsuario>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Olá, Usuário",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "Bem vindo de volta!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Card(
                child: Column(),
              )
          ],
        ),
      ),
    )
  }
}