import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_projeto_ti/widgets/bottom_nav.dart';
import 'package:flutter_projeto_ti/models/investimento.dart';
import 'package:flutter_projeto_ti/services/investimento_service.dart';

class TelaInvestimentos extends StatefulWidget {
  const TelaInvestimentos({super.key});

  @override
  State<TelaInvestimentos> createState() => _TelaInvestimentosState();
}

class _TelaInvestimentosState extends State<TelaInvestimentos> {
  double _calcularTotalInvestido(List<QueryDocumentSnapshot> docs) {
    double total = 0;
    for (var doc in docs) {
      final dados = doc.data() as Map<String, dynamic>;
      total += (dados['totalAportes'] as num).toDouble();
    }
    return total;
  }

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

    final timestamp = dados['dataSimulacao'] as Timestamp;
    final DateTime data = timestamp.toDate();
    final investimento = Investimento.fromJson({
      'id': id,
      ...dados,
      'dataSimulacao': data.toIso8601String(),
    });

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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/resultado-simulacao',
            arguments: investimento,
          );
        },
        onLongPress: () {
          _confirmarExclusao(id, investimento.tipo);
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: corIcone.withValues(alpha: 0.1), 
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: corIcone, size: 24),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    investimento.tipo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        dataFormatada,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.trending_up,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${investimento.prazoMeses} meses',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                      children: [
                        const TextSpan(text: "Rendimento: "),
                        TextSpan(
                          text: investimento.lucroLiquido >= 0
                              ? '+ R\$ ${investimento.lucroLiquido.toStringAsFixed(2)}'
                              : '- R\$ ${investimento.lucroLiquido.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            color: investimento.temLucro
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' (${investimento.rendimentoFormatado})',
                          style: TextStyle(
                            color: investimento.temLucro
                                ? Colors.green
                                : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'R\$ ${investimento.valorFinalLiquido.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: investimento.temLucro
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
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
                const SizedBox(height: 6),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
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
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            "Excluir investimento",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("Tem certeza que deseja excluir a simulação '$tipo'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                try {
                  await InvestimentoService.excluir(id);
                  if (!mounted) return; 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Investimento excluído com sucesso!"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
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
              child: const Text(
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
              return const Center(
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
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      "Erro ao carregar investimentos",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(snapshot.error.toString()),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text("Tentar novamente"),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Minhas Simulações",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context, "/simulador-investimentos",
                            );
                          },
                          icon: const Icon(Icons.add, size: 30),
                          color: Colors.blue.shade700,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
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
                          const SizedBox(height: 16),
                          Text(
                            "Nenhum investimento cadastrado",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Clique no + para simular um investimento",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context, "/simulador-investimentos",
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                            ),
                            child: const Text(
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

            final totalInvestido = _calcularTotalInvestido(docs);
            final rendimentoTotal = _calcularRendimentoTotal(docs);
            final percentualRendimento =
                _calcularPercentualRendimento(totalInvestido, rendimentoTotal);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Minhas simulações",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context, "/simulador-investimentos",
                          );
                        },
                        icon: const Icon(Icons.add, size: 30),
                        color: Colors.blue.shade700,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                        const Text(
                          "Total simulado",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "R\$ ${totalInvestido.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Rendimento total",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rendimentoTotal >= 0
                              ? '+ R\$ ${rendimentoTotal.toStringAsFixed(2)} (${percentualRendimento.toStringAsFixed(2)}%)'
                              : '- R\$ ${rendimentoTotal.abs().toStringAsFixed(2)} (${percentualRendimento.abs().toStringAsFixed(2)}%)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
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

                  const SizedBox(height: 24),

                  Text(
                    "${docs.length} ${docs.length == 1 ? 'investimento' : 'investimentos'}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return itemInvestimento(docs[index]);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(paginaAtual: 2),
    );
  }
}