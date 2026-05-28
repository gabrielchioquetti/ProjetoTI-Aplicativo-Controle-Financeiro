import 'package:flutter_projeto_ti/models/investimento.dart';

class InvestimentoController {

  static List<Investimento>
      listaInvestimentos = [

    Investimento(
      nome: "Tesouro Selic",
      valorInvestido: 2000,
      rendimento: 120,
      tipo: "Renda Fixa",
    ),

    Investimento(
      nome: "CDB Banco XYZ",
      valorInvestido: 1500,
      rendimento: 90,
      tipo: "CDB",
    ),
  ];

  static void adicionarInvestimento(
    Investimento investimento,
  ) {

    listaInvestimentos.add(
      investimento,
    );
  }

  static double totalInvestido() {

    double total = 0;

    for (
      var investimento
          in listaInvestimentos
    ) {

      total +=
          investimento.valorInvestido;
    }

    return total;
  }
}