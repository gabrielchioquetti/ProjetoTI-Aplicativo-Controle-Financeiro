// screens/investimentos.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_projeto_ti/widgets/bottom_nav.dart';
import 'package:flutter_projeto_ti/models/investimento.dart';
import 'package:flutter_projeto_ti/services/investimento_service.dart';

class TelaInvestimentos extends StatefulWidget {
  @override
  State<TelaInvestimentos> createState() => _TelaInvestimentos();
}

class _TelaInvestimentos extends State<TelaInvestimentos> {
  // Calcular total investido a partir dos documentos
  double _calcularTotalInvestido(List<QueryDocumentSnapshot> docs) {
    double total = 0;
    for (var doc in docs) {
      final dados = doc.data() as Map<String, dynamic>;
      total += (dados['totalAportes'] as num).toDouble();
    }
    return total;
  }

  // Calcular rendimento total
  double _calcularRendimentoTotal(List<QueryDocumentSnapshot> docs) {
    double total = 0;
    for (var doc in docs) {
      final dados = doc.data() as Map<String, dynamic>;
      total += (dados['lucroLiquido'] as num).toDouble();
    }
    return total;
  }

  // Calcular percentual de rendimento total
  double _calcularPercentualRendimento(double totalInvestido, double rendimentoTotal) {
    if (totalInvestido == 0) return 0;
    return (rendimentoTotal / totalInvestido) * 100;
  }

  Widget itemInvestimento(DocumentSnapshot doc) {
    final dados = doc.data() as Map<String, dynamic>;
    final id = doc.id;
    
    // Converter Timestamp para DateTime
    final timestamp = dados['dataSimulacao'] as Timestamp;
    final DateTime data = timestamp.toDate();
    
    // Criar objeto Investimento
    final investimento = Investimento.fromJson({
      'id': id,
      ...dados,
      'dataSimulacao': data.toIso8601String(),
    });

    // Definir ícone baseado no tipo
    IconData icone;
    Color corIcone;
    String tipo = investimento.tipo.toLowerCase();
    
    if (tipo.contains('tesouro')) {
      icone = Icons.account_balance;
      corIcone = Colors.green;
    } else if (tipo.contains('cdb')) {
      icone = Icons.apartment;
      corIcone = Colors.blue;
    } else if (tipo.contains('fundos') || tipo.contains('fundo')) {
      icone = Icons.bar_chart;
      corIcone = Colors.purple;
    } else if (tipo.contains('lca') || tipo.contains('lci')) {
      icone = Icons.house;
      corIcone = Colors.orange;
    } else if (tipo.contains('ações') || tipo.contains('acoes')) {
      icone = Icons.trending_up;
      corIcone = Colors.red;
    } else if (tipo.contains('poupança') || tipo.contains('poupanca')) {
      icone = Icons.savings;
      corIcone = Colors.teal;
    } else {
      icone = Icons.attach_money;
      corIcone = Colors.grey;
    }

    // Formatar data
    String dataFormatada = '${data.day}/${data.month}/${data.year}';

    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          // Navegar para detalhes do investimento
          Navigator.pushNamed(
            context,
            '/resultado-simulacao',
            arguments: investimento,
          );
        },
        onLongPress: () {
          // Long press para excluir
          _confirmarExclusao(id, investimento.tipo);
        },
        child: Row(
          children: [
            /// ÍCONE
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: corIcone.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: corIcone, size: 24),
            ),
            SizedBox(width: 14),

            /// TEXTO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    investimento.tipo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        dataFormatada,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.trending_up, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        '${investimento.prazoMeses} meses',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                      children: [
                        TextSpan(text: "Rendimento: "),
                        TextSpan(
                          text: investimento.lucroLiquido >= 0
                              ? '+ R\$ ${investimento.lucroLiquido.toStringAsFixed(2)}'
                              : '- R\$ ${investimento.lucroLiquido.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            color: investimento.temLucro ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' (${investimento.rendimentoFormatado})',
                          style: TextStyle(
                            color: investimento.temLucro ? Colors.green : Colors.red,
                            fontSize: 12,
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
                  'R\$ ${investimento.valorFinalLiquido.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: investimento.temLucro 
                        ? Colors.green.withOpacity(0.1) 
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    investimento.temLucro ? '✅ Lucro' : '⚠️ Prejuízo',
                    style: TextStyle(
                      color: investimento.temLucro ? Colors.green : Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarExclusao(String id, String tipo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Excluir investimento",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("Tem certeza que deseja excluir a simulação '$tipo'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await InvestimentoService.excluir(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Investimento excluído com sucesso!"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erro ao excluir: $e"),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(
                "Excluir",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: InvestimentoService.listar(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 16),
                    Text('Carregando investimentos...'),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      "Erro ao carregar investimentos",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(snapshot.error.toString()),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text("Tentar novamente"),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return SingleChildScrollView(
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
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/simulador-investimentos",
                            );
                          },
                          icon: Icon(Icons.add, size: 30),
                          color: Colors.blue.shade700,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    
                    Container(
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.trending_up_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Nenhum investimento cadastrado",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Clique no + para simular um investimento",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/simulador-investimentos",
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                            ),
                            child: Text(
                              'Fazer simulação',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            final docs = snapshot.data!.docs;
            
            // Calcular totais
            final totalInvestido = _calcularTotalInvestido(docs);
            final rendimentoTotal = _calcularRendimentoTotal(docs);
            final percentualRendimento = _calcularPercentualRendimento(totalInvestido, rendimentoTotal);

            return SingleChildScrollView(
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
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "/simulador-investimentos",
                          );
                        },
                        icon: Icon(Icons.add, size: 30),
                        color: Colors.blue.shade700,
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  /// CARD TOTAL
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          rendimentoTotal >= 0 
                              ? Colors.blue.shade700 
                              : Colors.red.shade700,
                          rendimentoTotal >= 0 
                              ? Colors.blue.shade500 
                              : Colors.red.shade500,
                        ],
                      ),
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
                          "R\$ ${totalInvestido.toStringAsFixed(2)}",
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
                          rendimentoTotal >= 0
                              ? '+ R\$ ${rendimentoTotal.toStringAsFixed(2)} (${percentualRendimento.toStringAsFixed(2)}%)'
                              : '- R\$ ${rendimentoTotal.abs().toStringAsFixed(2)} (${percentualRendimento.abs().toStringAsFixed(2)}%)',
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

                  /// LISTA DE INVESTIMENTOS
                  Text(
                    "${docs.length} ${docs.length == 1 ? 'investimento' : 'investimentos'}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  ...docs.map((doc) => itemInvestimento(doc)).toList(),

                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavWidget(paginaAtual: 2),
    );
  }
}