import 'package:flutter/material.dart';
import 'package:flutter_projeto_ti/models/investimento.dart';

class TelaResultadoSimulacao extends StatelessWidget {
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
            /// CARD PRINCIPAL
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    investimento.temLucro ? Colors.green.shade700 : Colors.red.shade700,
                    investimento.temLucro ? Colors.green.shade500 : Colors.red.shade500,
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
                        "Valor final estimado",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          investimento.tipo,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "R\$ ${investimento.valorFinalLiquido.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Em ${investimento.prazoFormatado}",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lucro Líquido",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            "R\$ ${investimento.lucroLiquido.toStringAsFixed(2)}",
                            style: TextStyle(
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
                          Text(
                            "Rendimento",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            investimento.rendimentoFormatado,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.show_chart,
                        color: Colors.white,
                        size: 40,
                      ),
                    ],
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
                  itemResumo("Tipo de Investimento", investimento.tipo),
                  itemResumo("Valor Inicial", "R\$ ${investimento.valorInicial.toStringAsFixed(2)}"),
                  itemResumo("Aporte Mensal", "R\$ ${investimento.aporteMensal.toStringAsFixed(2)}"),
                  itemResumo("Total Aportado", "R\$ ${investimento.totalAportes.toStringAsFixed(2)}"),
                  itemResumo("Valor Final Bruto", "R\$ ${investimento.valorFinalBruto.toStringAsFixed(2)}"),
                  itemResumo("Imposto de Renda", "R\$ ${investimento.impostoPago.toStringAsFixed(2)} (${investimento.aliquotaIR.toStringAsFixed(1)}%)"),
                  itemResumo("Taxa de Juros", "${investimento.taxaJurosAnual.toStringAsFixed(2)}% a.a."),
                ],
              ),
            ),

            SizedBox(height: 24),

            /// GRÁFICO DE EVOLUÇÃO
            Text(
              "Evolução do Investimento",
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
              child: _buildGraficoEvolucao(investimento),
            ),

            SizedBox(height: 24),

            /// BOTÕES DE AÇÃO
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Nova Simulação'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
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
      padding: EdgeInsets.symmetric(vertical: 8),
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Widget do gráfico de evolução
  Widget _buildGraficoEvolucao(Investimento investimento) {
    // Gerar dados de evolução mês a mês
    List<double> evolucao = _calcularEvolucao(
      valorInicial: investimento.valorInicial,
      aporteMensal: investimento.aporteMensal,
      prazoMeses: investimento.prazoMeses,
      taxaJurosAnual: investimento.taxaJurosAnual,
    );

    // Encontrar o maior valor para escala
    double maiorValor = evolucao.reduce((a, b) => a > b ? a : b);
    if (maiorValor == 0) maiorValor = 1;

    // Selecionar pontos para mostrar no gráfico (máximo 12)
    List<double> pontosMostrar = [];
    int totalPontos = evolucao.length;
    if (totalPontos <= 12) {
      pontosMostrar = evolucao;
    } else {
      int passo = (totalPontos / 12).ceil();
      for (int i = 0; i < totalPontos; i += passo) {
        pontosMostrar.add(evolucao[i]);
      }
      // Garantir que o último ponto está incluído
      if (pontosMostrar.last != evolucao.last) {
        pontosMostrar.add(evolucao.last);
      }
    }

    // Calcular altura máxima do gráfico (com margem)
    double alturaMaxima = maiorValor * 1.2;

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(pontosMostrar.length, (index) {
              double altura = (pontosMostrar[index] / alturaMaxima) * 180;
              String label = '';
              if (pontosMostrar.length <= 12) {
                label = '${index + 1}';
              } else {
                int mesReal = (index * (totalPontos / pontosMostrar.length)).round();
                label = mesReal.toString();
              }
              
              // Cor da barra baseada no valor atual vs valor inicial
              double corPercentual = pontosMostrar[index] / investimento.valorFinalLiquido;
              Color corBarra = Colors.blue.shade700;
              if (pontosMostrar[index] < investimento.valorInicial) {
                corBarra = Colors.orange.shade700;
              } else if (pontosMostrar[index] >= investimento.valorInicial * 1.5) {
                corBarra = Colors.green.shade700;
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Valor no topo da barra (opcional)
                  if (index % 3 == 0 || index == pontosMostrar.length - 1)
                    Text(
                      'R\$ ${pontosMostrar[index].toInt()}',
                      style: TextStyle(fontSize: 8, color: Colors.grey.shade600),
                    ),
                  SizedBox(height: 4),
                  Container(
                    width: 22,
                    height: altura > 5 ? altura : 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          corBarra.withOpacity(0.7),
                          corBarra,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: corBarra.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        SizedBox(height: 8),
        // Legenda
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mês',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  'Evolução',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  'Lucro',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Calcular evolução mês a mês
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