import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GraficoPizza extends StatelessWidget {
  final double receitas;
  final double despesas;

  const GraficoPizza({
    super.key,
    required this.receitas,
    required this.despesas,
  });

  @override
  Widget build(BuildContext context) {
    final total = receitas + despesas;

    if (total == 0) {
      return Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pie_chart_outline,
                size: 48,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 8),
              Text(
                "Sem dados para exibir",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
              Text(
                "Adicione transações para ver o gráfico",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Título
          Text(
            "Distribuição de Receitas e Despesas",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),

          SizedBox(height: 20),

          // Layout em Row: Gráfico + Informações
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gráfico de Pizza
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: receitas,
                          title: receitas > 0
                              ? '${((receitas / total) * 100).toStringAsFixed(1)}%'
                              : '',
                          color: Colors.green,
                          radius: 80,
                          titleStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          showTitle: receitas > 0,
                        ),
                        PieChartSectionData(
                          value: despesas,
                          title: despesas > 0
                              ? '${((despesas / total) * 100).toStringAsFixed(1)}%'
                              : '',
                          color: Colors.red,
                          radius: 80,
                          titleStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          showTitle: despesas > 0,
                        ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 35,
                      startDegreeOffset: -90,
                    ),
                    swapAnimationCurve: Curves.easeInOut,
                    swapAnimationDuration: Duration(milliseconds: 500),
                  ),
                ),
              ),

              SizedBox(width: 16),

              // Informações lado a lado
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    // Card Receitas
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_upward,
                              size: 16, color: Colors.green),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Receitas",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "R\$ ${receitas.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              Text(
                                "${((receitas / total) * 100).toStringAsFixed(1)}%",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.green.shade400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12),

                    // Card Despesas
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_downward,
                              size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Despesas",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "R\$ ${despesas.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade700,
                                ),
                              ),
                              Text(
                                "${((despesas / total) * 100).toStringAsFixed(1)}%",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12),

                    // Card Total
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.attach_money,
                              size: 16, color: Colors.blue.shade700),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            "R\$ ${total.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Barra de progresso comparativa (CORRIGIDA)
          LayoutBuilder(
            builder: (context, constraints) {
              final larguraDisponivel = constraints.maxWidth;

              return Column(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        // Receitas (verde)
                        Container(
                          width: (receitas / total) * larguraDisponivel,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(4),
                            ),
                          ),
                        ),
                        // Despesas (vermelho)
                        Container(
                          width: (despesas / total) * larguraDisponivel,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  // Percentuais
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${((receitas / total) * 100).toStringAsFixed(1)}% Receitas",
                        style: TextStyle(
                            fontSize: 11, color: Colors.green.shade700),
                      ),
                      Text(
                        "${((despesas / total) * 100).toStringAsFixed(1)}% Despesas",
                        style:
                            TextStyle(fontSize: 11, color: Colors.red.shade700),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
