import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_projeto_ti/widgets/grafico_pizza.dart';
import 'package:flutter_projeto_ti/widgets/bottom_nav.dart';
import 'package:flutter_projeto_ti/services/transacao_service.dart';

class TelaHome extends StatefulWidget {
  const TelaHome({super.key});

  @override
  State<TelaHome> createState() => _TelaHome();
}

class _TelaHome extends State<TelaHome> {
  String _nomeUsuario = "Usuário";

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  void _carregarDadosUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();
      if (doc.exists && mounted) {
        setState(() {
          _nomeUsuario = doc.data()?['nome'] ?? "Usuário";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: TransacaoService.listar(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    SizedBox(height: 16),
                    Text("Carregando dados..."),
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
                    const Text("Erro ao carregar dados"),
                    const SizedBox(height: 8),
                    Text(snapshot.error.toString()),
                  ],
                ),
              );
            }

            final docs = snapshot.data?.docs ?? [];

            return _HomeContent(
              docs: docs,
              nomeUsuario: _nomeUsuario,
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(paginaAtual: 0),
    );
  }
}

class _HomeContent extends StatefulWidget {
  final List<QueryDocumentSnapshot> docs;
  final String nomeUsuario;

  const _HomeContent({
    required this.docs,
    required this.nomeUsuario,
  });

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  DateTime _mesSelecionado = DateTime.now();

  Map<String, double> get _totais {
    double receitas = 0;
    double despesas = 0;

    for (var doc in widget.docs) {
      final dados = doc.data() as Map<String, dynamic>;
      final Timestamp timestamp = dados['data'];
      final DateTime data = timestamp.toDate();

      if (data.month == _mesSelecionado.month &&
          data.year == _mesSelecionado.year) {
        final valor = (dados['valor'] as num).toDouble();

        if (dados['entrada'] == true) {
          receitas += valor;
        } else {
          despesas += valor.abs();
        }
      }
    }

    return {
      'receitas': receitas,
      'despesas': despesas,
      'saldo': receitas - despesas,
    };
  }

  List<QueryDocumentSnapshot> get _ultimasTransacoes {
    final docsFiltrados = widget.docs.where((doc) {
      final dados = doc.data() as Map<String, dynamic>;
      final Timestamp timestamp = dados['data'];
      final DateTime data = timestamp.toDate();
      return data.month == _mesSelecionado.month &&
          data.year == _mesSelecionado.year;
    }).toList();

    docsFiltrados.sort((a, b) {
      final dataA = (a.data() as Map<String, dynamic>)['data'] as Timestamp;
      final dataB = (b.data() as Map<String, dynamic>)['data'] as Timestamp;
      return dataB.toDate().compareTo(dataA.toDate());
    });

    if (docsFiltrados.length > 5) {
      return docsFiltrados.sublist(0, 5);
    }
    return docsFiltrados;
  }

  String _getNomeMes(DateTime date) {
    const meses = [
      "Janeiro",
      "Fevereiro",
      "Março",
      "Abril",
      "Maio",
      "Junho",
      "Julho",
      "Agosto",
      "Setembro",
      "Outubro",
      "Novembro",
      "Dezembro"
    ];
    return "${meses[date.month - 1]} de ${date.year}";
  }

  Future<void> _selecionarMes() async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: _mesSelecionado,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (data != null && mounted) {
      setState(() {
        _mesSelecionado = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totais = _totais;
    final ultimasTransacoes = _ultimasTransacoes;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
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
                            "Olá, ${widget.nomeUsuario} 👋",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Bem-vindo de volta!",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/perfil");
                        },
                        icon: const Icon(Icons.person_outline, size: 30),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// CARD SALDO
                  Container(
                    padding: const EdgeInsets.all(24),
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
                            const Text(
                              "Saldo Total",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(Icons.attach_money, color: Colors.white),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "R\$ ${totais['saldo']?.toStringAsFixed(2) ?? '0.00'}",
                          style: TextStyle(
                            color: (totais['saldo'] ?? 0) >= 0
                                ? Colors.white
                                : Colors.red.shade200,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Receitas",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "R\$ ${totais['receitas']?.toStringAsFixed(2) ?? '0.00'}",
                                  style: const TextStyle(
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
                                const Text(
                                  "Despesas",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "R\$ ${totais['despesas']?.toStringAsFixed(2) ?? '0.00'}",
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

                  const SizedBox(height: 30),

                  /// RESUMO DO MÊS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Resumo do mês",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: _selecionarMes,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(_getNomeMes(_mesSelecionado)),
                              const SizedBox(width: 5),
                              const Icon(Icons.keyboard_arrow_down, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// GRÁFICO DE PIZZA (Importado do pacote externo widgets/grafico_pizza.dart)
                  GraficoPizza(
                    receitas: totais['receitas'] ?? 0,
                    despesas: totais['despesas'] ?? 0,
                  ),

                  const SizedBox(height: 30),

                  /// ÚLTIMAS TRANSAÇÕES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Últimas Transações",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/transacoes");
                        },
                        child: Text(
                          "Ver todas",
                          style: TextStyle(color: Colors.blue.shade700),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  if (ultimasTransacoes.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(40),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Nenhuma transação no período",
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: ultimasTransacoes.map((doc) {
                        final dados = doc.data() as Map<String, dynamic>;
                        final Timestamp timestamp = dados['data'];
                        final DateTime data = timestamp.toDate();
                        final bool entrada = dados['entrada'];
                        final double valor = (dados['valor'] as num).toDouble();

                        return Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: entrada
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                child: Icon(
                                  entrada
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: entrada ? Colors.green : Colors.red,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                dados['descricao'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(dados['categoria']),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${entrada ? "+" : "-"} R\$ ${valor.abs().toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color:
                                          entrada ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 0),
                          ],
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
