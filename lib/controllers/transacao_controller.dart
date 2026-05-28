import 'package:flutter_projeto_ti/models/transacao.dart';

class TransacaoController {

  static List<Transacao> listaTransacoes = [];

  static void adicionarTransacao(
    Transacao transacao,
  ) {
    listaTransacoes.add(
      transacao,
    );
  }

  static double get totalReceitas {

  double total = 0;

  for (var transacao
      in listaTransacoes) {

    if (transacao.entrada) {

      total += transacao.valor;
    }
  }

  return total;
 }

  static double get totalDespesas {
    double total = 0;
    for (var transacao in listaTransacoes) {
      if (!transacao.entrada) {
        total += transacao.valor;
      }
    }
    return total;
  }

  static double get saldoTotal {
    return totalReceitas - totalDespesas;
  }
}