import 'package:flutter/material.dart';
import 'package:flutter_projeto_ti/widgets/bottom_nav.dart';
import 'package:flutter_projeto_ti/controllers/transacao_controller.dart';

class TelaHome extends StatefulWidget {
  @override
  State<TelaHome> createState() => _TelaHome();
}

class _TelaHome extends State<TelaHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),

          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),

            child: Padding(
              padding: EdgeInsets.all(20),

              child: Center(
                child: Container(
                  padding: EdgeInsets.all(24),

                  constraints: BoxConstraints(maxWidth: 500),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(20),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "Olá, Gabriel 👋",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "Bem-vindo de volta!",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          IconButton(
                            onPressed: () {},

                            icon: Icon(Icons.notifications_none, size: 30),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),

                      /// CARD SALDO
                      Container(
                        padding: EdgeInsets.all(24),

                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade700,
                              Colors.blue.shade500,
                            ],
                          ),

                          borderRadius: BorderRadius.circular(24),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text(
                                  "Saldo Total",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),

                                Icon(Icons.visibility, color: Colors.white),
                              ],
                            ),

                            SizedBox(height: 15),

                            Text(
                              "R\$ ${TransacaoController.saldoTotal.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 25),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      "Receitas",
                                      style: TextStyle(color: Colors.white70),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      "R\$ ${TransacaoController.totalReceitas.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,

                                  children: [
                                    Text(
                                      "Despesas",
                                      style: TextStyle(color: Colors.white70),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      "R\$ ${TransacaoController.totalDespesas.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.red.shade100,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      /// RESUMO
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            "Resumo do mês",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,

                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Row(
                              children: [
                                Text("Maio"),

                                SizedBox(width: 5),

                                Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 25),

                      /// GRÁFICO PLACEHOLDER
                      Container(
                        height: 180,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Center(
                          child: Text(
                            "Gráfico do mês",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      /// TRANSAÇÕES
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            "Últimas Transações",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          TextButton(
                            onPressed: () {},

                            child: Text(
                              "Ver todas",
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),
                      Column(
                        children:
                            TransacaoController
                                .listaTransacoes
                                .reversed
                                .take(5)
                                .map((transacao) {
                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: transacao.entrada ? Colors.green.shade100 : Colors.red.shade100,
                                  child: Icon(
                                    transacao.entrada ? Icons.arrow_upward : Icons.arrow_downward,
                                    color: transacao.entrada ? Colors.green : Colors.red,
                                  ),
                                ),
                                title: Text(transacao.titulo,),
                                subtitle: Text( transacao.categoria,),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${transacao.entrada ? "+" : "-"} R\$ ${transacao.valor.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: transacao.entrada ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${transacao.data.day}/${transacao.data.month}",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      /// MENU INFERIOR
      bottomNavigationBar: BottomNavWidget(paginaAtual: 0),
    );
  }
}
