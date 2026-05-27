import 'package:flutter/material.dart';
import 'package:flutter_projeto_ti/widgets/bottom_nav.dart';
import 'package:flutter_projeto_ti/widgets/floating_button.dart';

class TelaNovaTransacao extends StatefulWidget {
  @override
  State<TelaNovaTransacao> createState() => _TelaNovaTransacao();
}

class _TelaNovaTransacao extends State<TelaNovaTransacao> {
  bool receita = true;

  final TextEditingController valorController = TextEditingController();

  final TextEditingController descricaoController = TextEditingController();

  final TextEditingController dataController = TextEditingController();

  String? categoriaSelecionada;

  final List<String> categorias = [
    "Salário",
    "Mercado",
    "Transporte",
    "Lazer",
    "Aluguel",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        centerTitle: true,

        title: Text(
          "Nova Transação",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        iconTheme: IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),

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
                  /// RECEITA
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

                  /// DESPESA
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

            SizedBox(height: 25),

            /// VALOR
            Text(
              "Valor",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 10),

            TextField(
              controller: valorController,

              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                hintText: "R\$ 0,00",

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20),

            /// CATEGORIA
            Text(
              "Categoria",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: categoriaSelecionada,

              decoration: InputDecoration(
                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),

                  borderSide: BorderSide.none,
                ),
              ),

              hint: Text("Selecionar categoria"),

              items: categorias.map((categoria) {
                return DropdownMenuItem(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  categoriaSelecionada = value;
                });
              },
            ),

            SizedBox(height: 20),

            /// DESCRIÇÃO
            Text(
              "Descrição",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 10),

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

            SizedBox(height: 20),

            /// DATA
            Text(
              "Data",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 10),

            TextField(
              controller: dataController,

              readOnly: true,

              decoration: InputDecoration(
                hintText: "20/05/2024",

                suffixIcon: Icon(Icons.calendar_today),

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

                  lastDate: DateTime(2030),

                  initialDate: DateTime.now(),
                );

                if (data != null) {
                  dataController.text =
                      "${data.day}/${data.month}/${data.year}";
                }
              },
            ),

            SizedBox(height: 40),

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

                onPressed: () {},

                child: Text(
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
      bottomNavigationBar: BottomNavWidget(paginaAtual: 1),

      floatingActionButton: FloatingButtonWidget(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
