import 'package:flutter/material.dart';
import 'package:flutter_projeto_ti/widgets/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_projeto_ti/services/transacao_service.dart';
import 'package:flutter_projeto_ti/utils/categorias.dart';

class TelaTransacoes extends StatefulWidget {
  const TelaTransacoes({super.key});
  @override
  State<TelaTransacoes> createState() => _TelaTransacoes();
}

class _TelaTransacoes extends State<TelaTransacoes> {
  int filtroSelecionado = 0; // 0 = Todas, 1 = Receitas, 2 = Despesas

  // Variáveis para os filtros avançados
  DateTime? _dataInicio;
  DateTime? _dataFim;
  String? _categoriaFiltro;

  // MÉTODO: Abrir modal de filtros avançados
  void _abrirFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filtrar Transações",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Filtro por período
                  Text(
                    "Período",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? data = await showDatePicker(
                              context: context,
                              initialDate: _dataInicio ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                              locale: Locale('pt', 'BR'),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.blue,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (data != null) {
                              setStateModal(() {
                                _dataInicio = data;
                              });
                              setState(() {
                                _dataInicio = data;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Data inicial",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _dataInicio != null
                                      ? "${_dataInicio!.day.toString().padLeft(2, '0')}/${_dataInicio!.month.toString().padLeft(2, '0')}/${_dataInicio!.year}"
                                      : "Selecionar",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? data = await showDatePicker(
                              context: context,
                              initialDate: _dataFim ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                              locale: Locale('pt', 'BR'),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.blue,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (data != null) {
                              setStateModal(() {
                                _dataFim = data;
                              });
                              setState(() {
                                _dataFim = data;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Data final",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _dataFim != null
                                      ? "${_dataFim!.day.toString().padLeft(2, '0')}/${_dataFim!.month.toString().padLeft(2, '0')}/${_dataFim!.year}"
                                      : "Selecionar",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Filtro por categoria COM ÍCONES
                  Text(
                    "Categoria",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: _categoriaFiltro,
                        hint: Text("Todas as categorias"),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text("Todas as categorias"),
                          ),
                          ...Categoria.todas.map((categoria) {
                            return DropdownMenuItem(
                              value: categoria.nome,
                              child: Text(categoria.nome),
                            );
                          }),
                        ],
                        onChanged: (String? valor) {
                          setStateModal(() {
                            _categoriaFiltro = valor;
                          });
                          setState(() {
                            _categoriaFiltro = valor;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Botões de ação
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setStateModal(() {
                              _dataInicio = null;
                              _dataFim = null;
                              _categoriaFiltro = null;
                            });
                            setState(() {
                              _dataInicio = null;
                              _dataFim = null;
                              _categoriaFiltro = null;
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Filtros limpos!"),
                                backgroundColor: Colors.orange,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text("Limpar filtros"),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text("Aplicar filtros"),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // MÉTODO: Editar transação
  Future<void> _editarTransacao(String id, Map<String, dynamic> dados) async {
    final resultado = await Navigator.pushNamed(
      context,
      "/editar-transacao",
      arguments: {
        'id': id,
        'descricao': dados['descricao'],
        'valor': dados['valor'],
        'categoria': dados['categoria'],
        'data': (dados['data'] as Timestamp).toDate(),
        'entrada': dados['entrada'],
      },
    );

    if (resultado == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Transação editada com sucesso!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // MÉTODO: Confirmar exclusão
  void _confirmarExclusao(String id, String titulo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Excluir transação",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("Tem certeza que deseja excluir '$titulo'?"),
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
                await _excluirTransacao(id, titulo);
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

  // MÉTODO: Excluir transação
  Future<void> _excluirTransacao(String id, String titulo) async {
    try {
      await TransacaoService.excluir(id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Transação '$titulo' excluída com sucesso!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao excluir: $e"),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // WIDGET: Item da transação
  Widget itemTransacao({
    required IconData icone,
    required Color corIcone,
    required String titulo,
    required String tipo,
    required String valor,
    required String data,
    required bool receita,
    required String id,
    required Map<String, dynamic> dados,
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
              color: corIcone.withValues(alpha: 0.1),
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
                  titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  tipo,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          /// VALOR E BOTÃO DE OPÇÕES
          Row(
            children: [
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
                  Text(
                    data,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),

              /// MENU DE OPÇÕES (3 pontinhos)
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey),
                onSelected: (String result) async {
                  if (result == 'editar') {
                    await _editarTransacao(id, dados);
                  } else if (result == 'excluir') {
                    _confirmarExclusao(id, titulo);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'editar',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text('Editar', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'excluir',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Excluir', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
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
                    /// TÍTULO E BOTÃO ADICIONAR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transações",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade600,
                                Colors.blue.shade400
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              final resultado = await Navigator.pushNamed(
                                context,
                                "/nova-transacao",
                              );
                              if (resultado == true && mounted) {
                                setState(() {});
                              }
                            },
                            icon:
                                Icon(Icons.add, size: 28, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),

                    /// FILTROS RÁPIDOS (Todas/Receitas/Despesas)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildFiltroItem("Todas", 0),
                          _buildFiltroItem("Receitas", 1),
                          _buildFiltroItem("Despesas", 2),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    /// MÊS E BOTÃO DE FILTRO AVANÇADO
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getMesAtual(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: _abrirFiltros,
                            icon: Icon(Icons.tune, color: Colors.blue.shade600),
                          ),
                        ),
                      ],
                    ),

                    /// INDICADOR DE FILTROS ATIVOS
                    if (_dataInicio != null ||
                        _dataFim != null ||
                        _categoriaFiltro != null)
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.filter_alt,
                                  size: 16, color: Colors.blue.shade700),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _getTextoFiltrosAtivos(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _dataInicio = null;
                                    _dataFim = null;
                                    _categoriaFiltro = null;
                                  });
                                },
                                child: Icon(Icons.close,
                                    size: 16, color: Colors.blue.shade700),
                              ),
                            ],
                          ),
                        ),
                      ),

                    SizedBox(height: 20),

                    /// LISTA DE TRANSAÇÕES COM FILTROS
                    StreamBuilder<QuerySnapshot>(
                      stream: TransacaoService.listar(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 300,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                  SizedBox(height: 16),
                                  Text("Carregando transações..."),
                                ],
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Container(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.error_outline,
                                      size: 48, color: Colors.red),
                                  SizedBox(height: 16),
                                  Text(
                                    "Erro ao carregar transações",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
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
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Container(
                            padding: EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Nenhuma transação cadastrada",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Clique no + para adicionar",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final docs = snapshot.data!.docs;

                        // APLICAR TODOS OS FILTROS
                        final docsFiltrados = docs.where((doc) {
                          final dados = doc.data() as Map<String, dynamic>;
                          final bool entrada = dados["entrada"];
                          final Timestamp timestamp = dados["data"];
                          final DateTime data = timestamp.toDate();
                          final String categoria = dados["categoria"];

                          // Filtro rápido (Todas/Receitas/Despesas)
                          if (filtroSelecionado == 1 && !entrada) {
                            return false;
                          }

                          if (filtroSelecionado == 2 && entrada) {
                            return false;
                          }

                          if (_dataInicio != null &&
                              data.isBefore(_dataInicio!)) {
                            return false;
                          }

                          if (_dataFim != null && data.isAfter(_dataFim!)) {
                            return false;
                          }

                          if (_categoriaFiltro != null &&
                              categoria != _categoriaFiltro) {
                            return false;
                          }

                          return true;
                        }).toList();

                        // Verificar se após o filtro não há resultados
                        if (docsFiltrados.isEmpty) {
                          return Container(
                            padding: EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.filter_alt_off,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Nenhuma transação encontrada",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Tente ajustar os filtros",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _dataInicio = null;
                                        _dataFim = null;
                                        _categoriaFiltro = null;
                                      });
                                    },
                                    child: Text("Limpar filtros"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: docsFiltrados.map((doc) {
                              final dados = doc.data() as Map<String, dynamic>;
                              final id = doc.id;
                              final Timestamp timestamp = dados["data"];
                              final DateTime data = timestamp.toDate();
                              final bool entrada = dados["entrada"];

                              return itemTransacao(
                                id: id,
                                dados: dados,
                                icone: entrada
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                corIcone: entrada ? Colors.green : Colors.red,
                                titulo: dados["descricao"],
                                tipo: dados["categoria"],
                                valor:
                                    "${entrada ? "+" : "-"} R\$ ${(dados["valor"] as num).abs().toStringAsFixed(2)}",
                                data:
                                    "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}",
                                receita: entrada,
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWidget(paginaAtual: 1),
    );
  }

  // Widget auxiliar para os filtros rápidos
  Widget _buildFiltroItem(String texto, int indice) {
    bool isSelected = filtroSelecionado == indice;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            filtroSelecionado = indice;
          });
        },
        child: Column(
          children: [
            Text(
              texto,
              style: TextStyle(
                color: isSelected ? Colors.blue.shade700 : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade700 : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para pegar o mês atual
  String _getMesAtual() {
    final now = DateTime.now();
    final meses = [
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
    return "${meses[now.month - 1]} de ${now.year}";
  }

  // Método para gerar texto dos filtros ativos
  String _getTextoFiltrosAtivos() {
    List<String> filtrosAtivos = [];

    if (_dataInicio != null || _dataFim != null) {
      String periodo = "Período: ";
      if (_dataInicio != null) {
        periodo +=
            "${_dataInicio!.day}/${_dataInicio!.month}/${_dataInicio!.year}";
      }
      if (_dataFim != null) {
        periodo += " até ${_dataFim!.day}/${_dataFim!.month}/${_dataFim!.year}";
      }
      filtrosAtivos.add(periodo);
    }

    if (_categoriaFiltro != null) {
      filtrosAtivos.add("Categoria: $_categoriaFiltro");
    }

    return filtrosAtivos.join(" • ");
  }
}