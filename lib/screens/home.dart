import 'package:flutter/material.dart';

class TelaHome extends StatefulWidget {
  @override
  State<TelaHome> createState() => _TelaHome();
}

class _TelaHome extends State<TelaHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(24),
                  constraints: BoxConstraints(
                    maxWidth: 400,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
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
                      Card(child: Column()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}