import 'package:flutter/material.dart';

class BottomNavWidget extends StatelessWidget {
  final int paginaAtual;

  const BottomNavWidget({super.key, required this.paginaAtual});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 10,
      child: SizedBox(
        height: 70,
        child: Row(
          children: [
            /// HOME
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/home");
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      color: paginaAtual == 0 ? Colors.blue.shade700 : Colors.grey,
                    ),
                    Text("Início"),
                  ],
                ),
              ),
            ),
            /// TRANSAÇÕES
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/transacoes");
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      color: paginaAtual == 1 ? Colors.blue.shade700 : Colors.grey,
                    ),
                    Text("Transações"),
                  ],
                ),
              ),
            ),
            SizedBox(width: 40),
            /// Investimentos
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/investimentos",);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: paginaAtual == 2 ? Colors.blue.shade700 : Colors.grey,
                    ),
                    Text("Investimentos"),
                  ],
                ),
              ),
            ),
            /// PERFIL
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/perfil");
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: paginaAtual == 3 ? Colors.blue.shade700 : Colors.grey,
                    ),
                    Text("Perfil"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
