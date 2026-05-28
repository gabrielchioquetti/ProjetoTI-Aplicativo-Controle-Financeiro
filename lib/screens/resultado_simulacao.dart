import 'package:flutter/material.dart';

class TelaResultadoSimulacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,

        elevation: 0,

        centerTitle: true,

        title: Text(
          "Resultado da Simulação",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// CARD VERDE
            Container(
              width: double.infinity,

              padding: EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.blue.shade700,

                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Valor final estimado",

                    style: TextStyle(color: Colors.white70),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "R\$ 3.041,68",

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 34,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text("Em 12 meses", style: TextStyle(color: Colors.white70)),

                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,

                    child: Icon(
                      Icons.show_chart,

                      color: Colors.white,

                      size: 40,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            /// RESUMO
            Container(
              padding: EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                children: [
                  itemResumo("Valor inicial", "R\$ 1.000,00"),

                  itemResumo("Total aportes", "R\$ 2.400,00"),

                  itemResumo("Total rendimentos", "R\$ 641,68"),

                  itemResumo("Taxa média anual", "10,40% a.a"),
                ],
              ),
            ),

            SizedBox(height: 24),

            /// GRÁFICO
            Text(
              "Gráfico de evolução",

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

            Container(
              height: 250,

              width: double.infinity,

              padding: EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        barraGrafico(40),
                        barraGrafico(80),
                        barraGrafico(120),
                        barraGrafico(160),
                        barraGrafico(190),
                        barraGrafico(220),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text("0"),
                      Text("3"),
                      Text("6"),
                      Text("9"),
                      Text("12"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemResumo(String titulo, String valor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(titulo, style: TextStyle(color: Colors.grey.shade700)),

          Text(valor, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget barraGrafico(double altura) {
    return Container(
      width: 28,
      height: altura,

      decoration: BoxDecoration(
        color: Colors.blue.shade700,

        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}