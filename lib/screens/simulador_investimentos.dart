import 'package:flutter/material.dart';
import 'package:flutter_projeto_ti/services/investimento_api_service.dart';
import 'package:flutter_projeto_ti/models/investimento.dart';
import 'package:flutter_projeto_ti/services/investimento_service.dart';

class TelaSimuladorInvestimentos extends StatefulWidget {
  @override
  State<TelaSimuladorInvestimentos> createState() =>
      _TelaSimuladorInvestimentosState();
}

class _TelaSimuladorInvestimentosState
    extends State<TelaSimuladorInvestimentos> {
  final TextEditingController valorInicialController = TextEditingController();
  final TextEditingController aporteMensalController = TextEditingController();
  final TextEditingController percentualCdiController = TextEditingController();
  final TextEditingController taxaManualController = TextEditingController();

  String investimentoSelecionado = "CDB";
  String tempoSelecionado = "12 meses";
  String tipoTaxaSelecionado = "percentual_cdi";

  bool _simulando = false;
  bool _carregando = true;
  List<String> _tiposInvestimento = [];
  Map<String, double> _taxas = {};

  final List<String> _opcoesCdi = List.generate(21, (index) => '${100 + index}%');
  String? _percentualCdiCustom;

  @override
  void initState() {
    super.initState();
    _carregarDados();
    percentualCdiController.text = '100';
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);
    try {
      final tipos = await InvestimentoApiService.getTiposInvestimento();
      final taxas = await InvestimentoApiService.getTaxasAtuais();

      setState(() {
        _tiposInvestimento = tipos;
        _taxas = taxas;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      print('Erro ao carregar dados: $e');
    }
  }

  double _getPercentualCdi() {
    if (_percentualCdiCustom != null) {
      String valor = _percentualCdiCustom!.replaceAll('%', '').trim();
      double percentual = double.tryParse(valor.replaceAll(',', '.')) ?? 100;
      return percentual / 100;
    }
    
    String valor = percentualCdiController.text.replaceAll('%', '').trim();
    if (valor.isEmpty) return 1.0;
    double percentual = double.tryParse(valor.replaceAll(',', '.')) ?? 100;
    return percentual / 100;
  }

  double _getTaxaRendimento() {
    if (tipoTaxaSelecionado == 'manual') {
      double taxa = double.tryParse(
        taxaManualController.text.replaceAll(',', '.')
      ) ?? 0;
      return taxa;
    } else {
      double taxaBase = _taxas[investimentoSelecionado] ?? 10.0;
      double percentual = _getPercentualCdi();
      return taxaBase * percentual;
    }
  }

  int _getMeses() {
    String numero = tempoSelecionado.replaceAll(' meses', '');
    return int.parse(numero);
  }

  String _getInfoInvestimento() {
    String tipo = investimentoSelecionado.toLowerCase();
    switch (tipo) {
      case 'cdb':
        return 'Renda Fixa | IR Regressivo | Garantido pelo FGC';
      case 'tesouro direto':
        return 'Tesouro Selic | IR Regressivo | Garantido pelo Governo';
      case 'lca':
        return 'Isento de IR | Crédito Agrícola | FGC';
      case 'lci':
        return 'Isento de IR | Crédito Imobiliário | FGC';
      case 'fundos de investimento':
        return 'Taxa de Administração | IR Regressivo | Diversificado';
      case 'ações':
        return 'Renda Variável | Sem garantia | Potencial maior';
      case 'poupança':
        return 'Isento de IR | Baixa rentabilidade | Liquidez diária';
      default:
        return '';
    }
  }

  Future<void> _simular() async {
    // Validações
    if (valorInicialController.text.isEmpty) {
      _mostrarErro('Digite o valor inicial');
      return;
    }

    if (aporteMensalController.text.isEmpty) {
      _mostrarErro('Digite o aporte mensal');
      return;
    }

    double taxa = _getTaxaRendimento();
    if (taxa <= 0) {
      _mostrarErro(tipoTaxaSelecionado == 'manual' 
          ? 'Digite uma taxa válida (ex: 10.5)' 
          : 'Digite um percentual do CDI válido (ex: 100, 105, 120)');
      return;
    }

    double valorInicial = double.tryParse(
      valorInicialController.text.replaceAll(',', '.').replaceAll('R\$', '').trim(),
    ) ?? 0;

    double aporteMensal = double.tryParse(
      aporteMensalController.text.replaceAll(',', '.').replaceAll('R\$', '').trim(),
    ) ?? 0;

    if (valorInicial <= 0) {
      _mostrarErro('Digite um valor inicial válido');
      return;
    }

    if (aporteMensal < 0) {
      _mostrarErro('Digite um aporte mensal válido');
      return;
    }

    setState(() => _simulando = true);

    try {
      int meses = _getMeses();

      final resultado = await InvestimentoApiService.simularInvestimento(
        valorInicial: valorInicial,
        aporteMensal: aporteMensal,
        prazoMeses: meses,
        taxaJurosAnual: taxa,
        tipoInvestimento: investimentoSelecionado,
      );

      // SALVAR NO FIRESTORE
      try {
        await InvestimentoService.salvar(resultado);
        print('Investimento salvo no Firestore!');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Simulação salva com sucesso!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        print('Erro ao salvar investimento: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Simulação calculada, mas erro ao salvar: $e'),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }

      // Navegar para tela de resultado
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/resultado-simulacao',
          arguments: resultado,
        );
      }
    } catch (e) {
      if (mounted) {
        _mostrarErro('Erro na simulação: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _simulando = false);
      }
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Simulador de Investimentos",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _carregando
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blue),
                  SizedBox(height: 16),
                  Text('Carregando dados...'),
                ],
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Container(
                  padding: EdgeInsets.all(20),
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
                      /// TIPO DE INVESTIMENTO
                      Text(
                        "Tipo de Investimento",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: investimentoSelecionado,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        items: _tiposInvestimento.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Row(
                              children: [
                                Text(item),
                                SizedBox(width: 8),
                                if (_taxas.containsKey(item))
                                  Text(
                                    '(${_taxas[item]?.toStringAsFixed(2) ?? 0}% a.a.)',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            investimentoSelecionado = value!;
                          });
                        },
                      ),

                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue.shade700, size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _getInfoInvestimento(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      /// VALOR INICIAL
                      Text(
                        "Valor Inicial",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: valorInicialController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: "R\$ 1.000,00",
                          prefixIcon: Icon(Icons.attach_money, color: Colors.grey.shade600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      /// APORTE MENSAL
                      Text(
                        "Aporte Mensal",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: aporteMensalController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: "R\$ 200,00",
                          prefixIcon: Icon(Icons.repeat, color: Colors.grey.shade600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      /// TIPO DE TAXA
                      Text(
                        "Definir Taxa",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tipoTaxaSelecionado = 'percentual_cdi';
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: tipoTaxaSelecionado == 'percentual_cdi'
                                        ? Colors.blue.shade700
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Percentual do CDI',
                                      style: TextStyle(
                                        color: tipoTaxaSelecionado == 'percentual_cdi'
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tipoTaxaSelecionado = 'manual';
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: tipoTaxaSelecionado == 'manual'
                                        ? Colors.blue.shade700
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Taxa Manual',
                                      style: TextStyle(
                                        color: tipoTaxaSelecionado == 'manual'
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      /// CAMPO DE TAXA (dinâmico)
                      if (tipoTaxaSelecionado == 'percentual_cdi') ...[
                        Text(
                          "Percentual do CDI",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        
                        Container(
                          height: 80,
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: _opcoesCdi.map((opcao) {
                              bool isSelected = _percentualCdiCustom == opcao ||
                                  (percentualCdiController.text == opcao.replaceAll('%', '') &&
                                      _percentualCdiCustom == null);
                              
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _percentualCdiCustom = opcao;
                                    percentualCdiController.text = opcao.replaceAll('%', '');
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.blue.shade700 : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    opcao,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.grey.shade700,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        
                        SizedBox(height: 12),
                        
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: percentualCdiController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _percentualCdiCustom = null;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Digite o percentual (ex: 103)",
                                  suffixText: "%",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'CDI Atual',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    '${_taxas['CDB']?.toStringAsFixed(2) ?? '10.75'}%',
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
                      ] else ...[
                        Text(
                          "Digite a Taxa Anual",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: taxaManualController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: "Ex: 10.5",
                            suffixText: "% a.a.",
                            prefixIcon: Icon(Icons.percent, color: Colors.grey.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                      
                      if (_getTaxaRendimento() > 0) ...[
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.trending_up, color: Colors.green.shade700),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Taxa calculada: ${_getTaxaRendimento().toStringAsFixed(2)}% a.a.',
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      SizedBox(height: 20),

                      /// TEMPO
                      Text(
                        "Tempo de investimento",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: tempoSelecionado,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        items: ["12 meses", "24 meses", "36 meses", "60 meses", "120 meses"].map((
                          item,
                        ) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            tempoSelecionado = value!;
                          });
                        },
                      ),

                      SizedBox(height: 30),

                      /// BOTÃO
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _simulando ? null : _simular,
                          child: _simulando
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Calcular e Salvar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    valorInicialController.dispose();
    aporteMensalController.dispose();
    percentualCdiController.dispose();
    taxaManualController.dispose();
    super.dispose();
  }
}