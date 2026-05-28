import 'package:flutter/material.dart';

import 'package:flutter_projeto_ti/widgets/bottom_nav.dart';
import 'package:flutter_projeto_ti/widgets/floating_button.dart';

class TelaInvestimentos extends StatefulWidget {
  @override
  State<TelaInvestimentos> createState() => _TelaInvestimentos();
}

class _TelaInvestimentos extends State<TelaInvestimentos> {
  Widget itemInvestimento({
    required IconData icone,
    required Color corIcone,
    required String titulo,
    required String valor,
    required String rendimento,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),

      padding: EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          /// ÍCONE
          Container(
            padding: EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: corIcone.withOpacity(0.1),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icone, color: corIcone),
          ),

          SizedBox(width: 14),

          /// TEXTO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  titulo,

                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                SizedBox(height: 4),

                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey, fontSize: 13),

                    children: [
                      TextSpan(text: "Rendimento: "),

                      TextSpan(
                        text: rendimento,

                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// VALOR
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Text(
                valor,

                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              SizedBox(height: 6),

              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// TOPO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Meus Investimentos",

                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                ],
              ),

              SizedBox(height: 20),

              /// CARD TOTAL
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
                      "Total Investido",

                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "R\$ 5.000,00",

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 34,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Rendimento total",

                      style: TextStyle(color: Colors.white70),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "+ R\$ 320,00 (6,40%)",

                      style: TextStyle(
                        color: Colors.white,

                        fontWeight: FontWeight.bold,

                        fontSize: 18,
                      ),
                    ),

                    SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerRight,

                      child: Icon(
                        Icons.show_chart,

                        color: Colors.white,

                        size: 42,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              /// LISTA
              itemInvestimento(
                icone: Icons.account_balance,

                corIcone: Colors.green,

                titulo: "Tesouro Selic",

                valor: "R\$ 2.000,00",

                rendimento: "+ R\$ 120,00",
              ),

              itemInvestimento(
                icone: Icons.apartment,

                corIcone: Colors.blue,

                titulo: "CDB Banco XYZ",

                valor: "R\$ 2.000,00",

                rendimento: "+ R\$ 160,00",
              ),

              itemInvestimento(
                icone: Icons.bar_chart,

                corIcone: Colors.purple,

                titulo: "Fundos Imobiliários",

                valor: "R\$ 1.000,00",

                rendimento: "+ R\$ 40,00",
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavWidget(paginaAtual: 2),

      floatingActionButton: FloatingButtonWidget(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
