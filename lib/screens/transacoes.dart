import 'package:flutter/material.dart';

import 'package:flutter_projeto_ti/widgets/bottom_nav.dart';
import 'package:flutter_projeto_ti/widgets/floating_button.dart';

class TelaTransacoes extends StatefulWidget {
  @override
  State<TelaTransacoes> createState() => _TelaTransacoes();
}

class _TelaTransacoes extends State<TelaTransacoes> {
  int filtroSelecionado = 0;

  Widget itemTransacao({
    required IconData icone,
    required Color corIcone,
    required String titulo,
    required String tipo,
    required String valor,
    required String data,
    required bool receita,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),

      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
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

                Text(tipo, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          /// VALOR
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Text(
                valor,

                style: TextStyle(
                  color: receita ? Colors.green : Colors.red,

                  fontWeight: FontWeight.bold,

                  fontSize: 16,
                ),
              ),

              SizedBox(height: 4),

              Text(data, style: TextStyle(color: Colors.grey)),
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// TÍTULO
                    Text(
                      "Transações",

                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 25),

                    /// FILTROS
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                filtroSelecionado = 0;
                              });
                            },

                            child: Column(
                              children: [
                                Text(
                                  "Todas",

                                  style: TextStyle(
                                    color: filtroSelecionado == 0
                                        ? Colors.blue.shade700
                                        : Colors.grey,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 10),

                                Container(
                                  height: 3,

                                  decoration: BoxDecoration(
                                    color: filtroSelecionado == 0
                                        ? Colors.blue.shade700
                                        : Colors.transparent,

                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                filtroSelecionado = 1;
                              });
                            },

                            child: Column(
                              children: [
                                Text(
                                  "Receitas",

                                  style: TextStyle(
                                    color: filtroSelecionado == 1
                                        ? Colors.blue.shade700
                                        : Colors.grey,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 10),

                                Container(
                                  height: 3,

                                  decoration: BoxDecoration(
                                    color: filtroSelecionado == 1
                                        ? Colors.blue.shade700
                                        : Colors.transparent,

                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                filtroSelecionado = 2;
                              });
                            },

                            child: Column(
                              children: [
                                Text(
                                  "Despesas",

                                  style: TextStyle(
                                    color: filtroSelecionado == 2
                                        ? Colors.blue.shade700
                                        : Colors.grey,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 10),

                                Container(
                                  height: 3,

                                  decoration: BoxDecoration(
                                    color: filtroSelecionado == 2
                                        ? Colors.blue.shade700
                                        : Colors.transparent,

                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    /// MÊS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          "Maio de 2024",

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Icon(Icons.tune),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    /// TRANSAÇÕES
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Column(
                        children: [
                          itemTransacao(
                            icone: Icons.work,
                            corIcone: Colors.green,
                            titulo: "Salário",
                            tipo: "Receita",
                            valor: "+ R\$ 3.000,00",
                            data: "05/05",
                            receita: true,
                          ),

                          itemTransacao(
                            icone: Icons.shopping_cart,
                            corIcone: Colors.orange,
                            titulo: "Mercado",
                            tipo: "Despesa",
                            valor: "- R\$ 150,00",
                            data: "04/05",
                            receita: false,
                          ),

                          itemTransacao(
                            icone: Icons.local_gas_station,
                            corIcone: Colors.red,
                            titulo: "Combustível",
                            tipo: "Despesa",
                            valor: "- R\$ 100,00",
                            data: "03/05",
                            receita: false,
                          ),

                          itemTransacao(
                            icone: Icons.computer,
                            corIcone: Colors.green,
                            titulo: "Freelance",
                            tipo: "Receita",
                            valor: "+ R\$ 500,00",
                            data: "02/05",
                            receita: true,
                          ),

                          itemTransacao(
                            icone: Icons.restaurant,
                            corIcone: Colors.orange,
                            titulo: "Restaurante",
                            tipo: "Despesa",
                            valor: "- R\$ 80,00",
                            data: "01/05",
                            receita: false,
                          ),

                          itemTransacao(
                            icone: Icons.wifi,
                            corIcone: Colors.red,
                            titulo: "Internet",
                            tipo: "Despesa",
                            valor: "- R\$ 120,00",
                            data: "01/05",
                            receita: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavWidget(paginaAtual: 1),

      floatingActionButton: FloatingButtonWidget(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
