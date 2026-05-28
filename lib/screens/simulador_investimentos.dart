import 'package:flutter/material.dart';

class TelaSimuladorInvestimentos extends StatefulWidget {
  @override
  State<TelaSimuladorInvestimentos> createState() =>
      _TelaSimuladorInvestimentos();
}

class _TelaSimuladorInvestimentos extends State<TelaSimuladorInvestimentos> {
  final TextEditingController valorInicialController = TextEditingController();

  final TextEditingController aporteMensalController = TextEditingController();

  String investimentoSelecionado = "CDI";

  String rendimentoSelecionado = "100% do CDI (10,40% a.a)";

  String tempoSelecionado = "12 meses";

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

      body: SafeArea(
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
                /// TIPO
                Text(
                  "Tipo de Investimento",

                  style: TextStyle(color: Colors.grey.shade700),
                ),

                SizedBox(height: 8),

                DropdownButtonFormField(
                  value: investimentoSelecionado,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  items: ["CDI", "Tesouro Direto", "CDB", "Fundos"].map((item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      investimentoSelecionado = value!;
                    });
                  },
                ),

                SizedBox(height: 20),

                /// VALOR INICIAL
                Text(
                  "Valor Inicial",

                  style: TextStyle(color: Colors.grey.shade700),
                ),

                SizedBox(height: 8),

                TextField(
                  controller: valorInicialController,

                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                    hintText: "R\$ 1.000,00",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                /// APORTE
                Text(
                  "Aporte Mensal",

                  style: TextStyle(color: Colors.grey.shade700),
                ),

                SizedBox(height: 8),

                TextField(
                  controller: aporteMensalController,

                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                    hintText: "R\$ 200,00",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                /// RENDIMENTO
                Text(
                  "Taxa de Rendimento (ao ano)",

                  style: TextStyle(color: Colors.grey.shade700),
                ),

                SizedBox(height: 8),

                DropdownButtonFormField(
                  value: rendimentoSelecionado,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  items:
                      [
                        "100% do CDI (10,40% a.a)",
                        "110% do CDI",
                        "120% do CDI",
                      ].map((item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),

                  onChanged: (value) {
                    setState(() {
                      rendimentoSelecionado = value!;
                    });
                  },
                ),

                SizedBox(height: 20),

                /// TEMPO
                Text(
                  "Tempo de investimento",

                  style: TextStyle(color: Colors.grey.shade700),
                ),

                SizedBox(height: 8),

                DropdownButtonFormField(
                  value: tempoSelecionado,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  items: ["12 meses", "24 meses", "36 meses", "60 meses"].map((
                    item,
                  ) {
                    return DropdownMenuItem(value: item, child: Text(item));
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

                    onPressed: () {
                      Navigator.pushNamed(context, "/resultado-simulacao",);
                    },

                    child: Text(
                      "Calcular",

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
}