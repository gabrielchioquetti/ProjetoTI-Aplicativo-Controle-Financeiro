// screens/tela_editar_transacao.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_projeto_ti/services/transacao_service.dart';
import 'package:flutter_projeto_ti/utils/categorias.dart';

class TelaEditarTransacao extends StatefulWidget {
  @override
  State<TelaEditarTransacao> createState() => _TelaEditarTransacaoState();
}

class _TelaEditarTransacaoState extends State<TelaEditarTransacao> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  late String _categoriaSelecionada;
  late bool _ehReceita;
  late DateTime _dataSelecionada;
  late String _transacaoId;
  bool _salvando = false;

  // Usando categorias centralizadas
  final List<String> _categorias = Categoria.nomes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Receber os argumentos com segurança
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    _transacaoId = args['id'];
    _descricaoController.text = args['descricao'];

    // Tratar o valor para mostrar apenas o número positivo
    double valorOriginal = args['valor'];
    _valorController.text = valorOriginal.abs().toStringAsFixed(2);

    _categoriaSelecionada = args['categoria'];
    _ehReceita = args['entrada'];
    _dataSelecionada = args['data'];

    // Verificar se a categoria selecionada existe na lista
    if (!_categorias.contains(_categoriaSelecionada)) {
      _categoriaSelecionada = "Outros";
    }
  }

  Future<void> _salvarEdicao() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      double valor = double.parse(_valorController.text.replaceAll(',', '.'));

      await TransacaoService.atualizar(
        id: _transacaoId,
        descricao: _descricaoController.text,
        valor: _ehReceita ? valor : -valor,
        categoria: _categoriaSelecionada,
        data: _dataSelecionada,
        entrada: _ehReceita,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Transação editada com sucesso!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao salvar: ${e.toString()}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Transação"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Card de tipo (Receita/Despesa)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _ehReceita = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !_ehReceita
                                ? Colors.red.shade50
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Despesa",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: !_ehReceita ? Colors.red : Colors.grey,
                              fontWeight: !_ehReceita
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _ehReceita = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _ehReceita
                                ? Colors.green.shade50
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Receita",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: _ehReceita ? Colors.green : Colors.grey,
                              fontWeight: _ehReceita
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Campo Descrição
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  hintText: "Ex: Compras do mês",
                  prefixIcon: Icon(Icons.description, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira uma descrição";
                  }
                  if (value.length < 3) {
                    return "Descrição muito curta";
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Campo Valor
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: "Valor",
                  hintText: "0,00",
                  prefixIcon: Icon(Icons.attach_money, color: Colors.blue),
                  prefixText: "R\$ ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira um valor";
                  }
                  String valorLimpo = value.replaceAll(',', '.');
                  double? valor = double.tryParse(valorLimpo);
                  if (valor == null || valor <= 0) {
                    return "Por favor, insira um valor válido maior que zero";
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Dropdown Categoria
              DropdownButtonFormField<String>(
                value: _categoriaSelecionada,
                decoration: InputDecoration(
                  labelText: "Categoria",
                  prefixIcon: Icon(Icons.category, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                items: Categoria.todas.map((categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria.nome,
                    child: Row(
                      children: [
                        Icon(categoria.icone, size: 20, color: Colors.blue),
                        SizedBox(width: 12),
                        Text(categoria.nome),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? novoValor) {
                  if (novoValor != null) {
                    setState(() {
                      _categoriaSelecionada = novoValor;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Selecione uma categoria";
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Campo Data
              GestureDetector(
                onTap: () async {
                  DateTime? novaData = await showDatePicker(
                    context: context,
                    initialDate: _dataSelecionada,
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
                  if (novaData != null && mounted) {
                    setState(() {
                      _dataSelecionada = novaData;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Data da transação",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "${_dataSelecionada.day.toString().padLeft(2, '0')}/${_dataSelecionada.month.toString().padLeft(2, '0')}/${_dataSelecionada.year}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 32),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _salvarEdicao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _salvando
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Salvar Alterações",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }
}
