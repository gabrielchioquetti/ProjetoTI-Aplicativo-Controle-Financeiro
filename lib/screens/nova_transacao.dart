import 'package:flutter/material.dart';
import 'package:flutter_projeto_ti/services/transacao_service.dart';
import 'package:flutter_projeto_ti/utils/categorias.dart';
import 'package:flutter_projeto_ti/widgets/bottom_nav.dart';

class TelaNovaTransacao extends StatefulWidget {
  const TelaNovaTransacao({super.key});

  @override
  State<TelaNovaTransacao> createState() => _TelaNovaTransacao();
}

class _TelaNovaTransacao extends State<TelaNovaTransacao> {
  bool receita = true;
  bool _salvando = false;

  final TextEditingController valorController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  String? categoriaSelecionada;
  DateTime? dataSelecionada;

  @override
  void dispose() {
    valorController.dispose();
    descricaoController.dispose();
    dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Nova Transação",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// RECEITA / DESPESA
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          receita = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: receita
                              ? Colors.blue.shade700
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            "Receita",
                            style: TextStyle(
                              color: receita ? Colors.white : Colors.black,
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
                          receita = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: !receita
                              ? Colors.red.shade400
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            "Despesa",
                            style: TextStyle(
                              color: !receita ? Colors.white : Colors.black,
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
            const SizedBox(height: 25),

            /// VALOR
            Text(
              "Valor",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: valorController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: "R\$ 0,00",
                prefixText: "R\$ ",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Categoria",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: categoriaSelecionada,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: const Text("Selecionar categoria"),
              items: Categoria.todas.map((categoria) {
                return DropdownMenuItem(
                  value: categoria.nome,
                  child: Row(
                    children: [
                      Icon(categoria.icone, size: 20, color: Colors.blue),
                      const SizedBox(width: 12),
                      Text(categoria.nome),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  categoriaSelecionada = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Selecione uma categoria";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            /// DESCRIÇÃO
            Text(
              "Descrição",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(
                hintText: "Ex: Salário, Mercado...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// DATA
            Text(
              "Data",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dataController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "DD/MM/AAAA",
                suffixIcon:
                    const Icon(Icons.calendar_today, color: Colors.blue),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () async {
                DateTime? data = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDate: DateTime.now(),
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
                if (!mounted) return;

                if (data != null) {
                  setState(() {
                    dataSelecionada = data;
                    dataController.text =
                        "${data.day.toString().padLeft(2, '0')}/"
                        "${data.month.toString().padLeft(2, '0')}/"
                        "${data.year}";
                  });
                }
              },
            ),
            const SizedBox(height: 40),

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
                onPressed: _salvando ? null : _salvarTransacao,
                child: _salvando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Salvar Transação",
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
      bottomNavigationBar: const BottomNavWidget(paginaAtual: 1),
    );
  }

  Future<void> _salvarTransacao() async {
    if (valorController.text.isEmpty) {
      _mostrarErro("Digite um valor");
      return;
    }

    if (descricaoController.text.isEmpty) {
      _mostrarErro("Digite uma descrição");
      return;
    }

    if (categoriaSelecionada == null) {
      _mostrarErro("Selecione uma categoria");
      return;
    }

    if (dataSelecionada == null) {
      _mostrarErro("Selecione uma data");
      return;
    }

    String valorLimpo = valorController.text.replaceAll(",", ".");
    double? valor = double.tryParse(valorLimpo);

    if (valor == null || valor <= 0) {
      _mostrarErro("Digite um valor válido maior que zero");
      return;
    }

    if (mounted) {
      setState(() {
        _salvando = true;
      });
    }

    try {
      await TransacaoService.salvar(
        descricao: descricaoController.text,
        valor: receita ? valor : -valor,
        categoria: categoriaSelecionada!,
        data: dataSelecionada!,
        entrada: receita,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Transação salva com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao salvar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  void _mostrarErro(String mensagem) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
