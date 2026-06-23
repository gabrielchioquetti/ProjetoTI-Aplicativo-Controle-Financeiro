import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_projeto_ti/models/investimento.dart';

class TelaResultadoSimulacao extends StatelessWidget {
  const TelaResultadoSimulacao({super.key});

  @override
  Widget build(BuildContext context) {
    final investimento =
        ModalRoute.of(context)!.settings.arguments as Investimento;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Resultado da Simulação",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CARD PRINCIPAL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    investimento.temLucro
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    investimento.temLucro
                        ? Colors.green.shade500
                        : Colors.red.shade500,
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
                      const Text(
                        "Valor final estimado",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          investimento.tipo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "R\$ ${investimento.valorFinalLiquido.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Em ${investimento.prazoFormatado}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Lucro Líquido",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            "R\$ ${investimento.lucroLiquido.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Rendimento",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            investimento.rendimentoFormatado,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.show_chart,
                        color: Colors.white,
                        size: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// RESUMO
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  itemResumo("Tipo de Investimento", investimento.tipo),
                  itemResumo("Valor Inicial",
                      "R\$ ${investimento.valorInicial.toStringAsFixed(2)}"),
                  itemResumo("Aporte Mensal",
                      "R\$ ${investimento.aporteMensal.toStringAsFixed(2)}"),
                  itemResumo("Total Aportado",
                      "R\$ ${investimento.totalAportes.toStringAsFixed(2)}"),
                  itemResumo("Valor Final Bruto",
                      "R\$ ${investimento.valorFinalBruto.toStringAsFixed(2)}"),
                  itemResumo("Imposto de Renda",
                      "R\$ ${investimento.impostoPago.toStringAsFixed(2)} (${investimento.aliquotaIR.toStringAsFixed(1)}%)"),
                  itemResumo("Taxa de Juros",
                      "${investimento.taxaJurosAnual.toStringAsFixed(2)}% a.a."),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Evolução do Investimento",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Container(
              height: 260,
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 10, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: _buildGraficoEvolucao(investimento),
            ),

            const SizedBox(height: 24),

            /// BOTÕES DE AÇÃO
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Nova Simulação'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Voltar ao Início',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget itemResumo(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraficoEvolucao(Investimento investimento) {
    List<double> evolucao = _calcularEvolucao(
      valorInicial: investimento.valorInicial,
      aporteMensal: investimento.aporteMensal,
      prazoMeses: investimento.prazoMeses,
      taxaJurosAnual: investimento.taxaJurosAnual,
    );

    // 1. Agora passamos TODOS os meses para o gráfico. Sem filtros manuais!
    List<FlSpot> spots = [];
    for (int i = 0; i < evolucao.length; i++) {
      spots.add(FlSpot(i.toDouble(), evolucao[i]));
    }

    // 2. Calculamos dinamicamente de quanto em quanto tempo a legenda deve aparecer
    // Se forem muitos meses (ex: 48 meses), mostra de 6 em 6 ou 12 em 12.
    double intervaloLegenda = (evolucao.length / 5).ceilToDouble();
    if (intervaloLegenda < 1) intervaloLegenda = 1;

    final corLinha =
        investimento.temLucro ? Colors.green.shade600 : Colors.blue.shade600;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade100,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                if (value == meta.max || value == meta.min) {
                  return const SizedBox();
                }
                String valorFormatado = value >= 1000
                    ? '${(value / 1000).toStringAsFixed(0)}k'
                    : value.toStringAsFixed(0);
                return Text(
                  'R\$ $valorFormatado',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              // A MÁGICA ESTÁ AQUI: O fl_chart controla o espaçamento e não repete números!
              interval: intervaloLegenda,
              getTitlesWidget: (value, meta) {
                // Evita mostrar números além do prazo final real
                if (value > investimento.prazoMeses) return const SizedBox();

                return Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    'Mês ${value.toInt()}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.grey.shade900,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  'Mês ${spot.x.toInt()}\nR\$ ${spot.y.toStringAsFixed(2)}',
                  const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.15, // Suavizado leve para prazos menores
            color: corLinha,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  corLinha.withValues(alpha: 0.2),
                  corLinha.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<double> _calcularEvolucao({
    required double valorInicial,
    required double aporteMensal,
    required int prazoMeses,
    required double taxaJurosAnual,
  }) {
    double taxaMensal = (taxaJurosAnual / 100) / 12;
    List<double> evolucao = [];
    double valorAtual = valorInicial;

    for (int i = 0; i <= prazoMeses; i++) {
      if (i > 0) {
        valorAtual = valorAtual * (1 + taxaMensal);
        valorAtual += aporteMensal;
      }
      evolucao.add(valorAtual);
    }

    return evolucao;
  }
}
