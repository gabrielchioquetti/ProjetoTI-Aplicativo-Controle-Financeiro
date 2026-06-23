// lib/services/investimento_api_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_projeto_ti/models/investimento.dart';

class InvestimentoApiService {
  // URL base da API do Banco Central para séries temporais
  static const String baseUrlBacen = 'https://api.bcb.gov.br';

  // Busca a taxa SELIC META atualizada (Série 432 do SGS)
  static Future<double> _obterSelicAtual() async {
    // Data atual e data de 10 anos atrás (máximo permitido)
    final now = DateTime.now();
    final dezAnosAtras = DateTime(now.year - 10, now.month, now.day);

    // Formatar datas no formato dd/mm/aaaa
    String dataInicial = _formatarData(dezAnosAtras);
    String dataFinal = _formatarData(now);

    final url = Uri.parse('$baseUrlBacen/dados/serie/bcdata.sgs.432/dados' '?formato=json' '&dataInicial=$dataInicial' '&dataFinal=$dataFinal');
    final response = await http.get(url,headers: {'Accept': 'application/json'},);

    if (response.statusCode == 200) {
      List<dynamic> dados = jsonDecode(response.body);
      if (dados.isNotEmpty) {
        // Pegar o último valor (mais recente)
        var ultimo = dados.last;
        String valorStr = ultimo['valor'].toString().replaceAll(',', '.');
        double selic = double.parse(valorStr);
        return selic;
      }
    }
    // Fallback seguro
    return 10.75;
  }

  // Formatar data para dd/mm/aaaa
  static String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}' '/${data.month.toString().padLeft(2, '0')}' '/${data.year}';
  }

  // Restante do código permanece igual...

  // Método principal de simulação
  static Future<Investimento> simularInvestimento({
    required double valorInicial,
    required double aporteMensal,
    required int prazoMeses,
    required double taxaJurosAnual,
    required String tipoInvestimento,
  }) async {
    try {
      double taxaSelic = await _obterSelicAtual();
      double taxaFinal = taxaJurosAnual;
      String tipo = tipoInvestimento.toLowerCase();

      // Regras de mercado baseadas na taxa Selic oficial obtida
      if (tipo == 'poupança' || tipo == 'poupanca') {
        if (taxaSelic > 8.5) {
          taxaFinal = 6.17;
        } else {
          taxaFinal = 0.7 * taxaSelic;
        }
      } else if (tipo == 'cdb') {
        taxaFinal = taxaJurosAnual; // Já vem com o percentual aplicado
      } else if (tipo == 'lca' || tipo == 'lci') {
        taxaFinal = taxaJurosAnual;
      } else if (tipo == 'tesouro direto') {
        taxaFinal = taxaJurosAnual;
      } else if (tipo == 'fundos de investimento' || tipo == 'fundos') {
        taxaFinal = taxaJurosAnual;
      }

      double aliquotaIR = _calcularAliquotaIR(tipoInvestimento, prazoMeses);

      return _simularLocalmente(
        valorInicial: valorInicial,
        aporteMensal: aporteMensal,
        prazoMeses: prazoMeses,
        taxaJurosAnual: taxaFinal,
        tipoInvestimento: tipoInvestimento,
        aliquotaIR: aliquotaIR,
      );
    } catch (e) {
      double aliquotaIR = _calcularAliquotaIR(tipoInvestimento, prazoMeses);
      return _simularLocalmente(
        valorInicial: valorInicial,
        aporteMensal: aporteMensal,
        prazoMeses: prazoMeses,
        taxaJurosAnual: taxaJurosAnual,
        tipoInvestimento: tipoInvestimento,
        aliquotaIR: aliquotaIR,
      );
    }
  }

  static double _calcularAliquotaIR(String tipoInvestimento, int prazoMeses) {
    String tipo = tipoInvestimento.toLowerCase();

    if (tipo == 'poupança' ||
        tipo == 'poupanca' ||
        tipo == 'lca' ||
        tipo == 'lci') {
      return 0.0;
    }

    if (tipo == 'cdb' ||
        tipo == 'tesouro direto' ||
        tipo == 'fundos de investimento' ||
        tipo == 'fundos') {
      int dias = prazoMeses * 30;
      if (dias <= 180) {
        return 0.225;
      } else if (dias <= 360) {
        return 0.20;
      } else if (dias <= 720) {
        return 0.175;
      } else {
        return 0.15;
      }
    }

    return 0.15;
  }

  static Investimento _simularLocalmente({
    required double valorInicial,
    required double aporteMensal,
    required int prazoMeses,
    required double taxaJurosAnual,
    required String tipoInvestimento,
    required double aliquotaIR,
  }) {
    double taxaPercentualAnual = taxaJurosAnual / 100;
    double taxaMensal = pow(1 + taxaPercentualAnual, 1 / 12) - 1;

    double valorFinalBruto = valorInicial;
    double totalAportes = valorInicial;

    for (int i = 0; i < prazoMeses; i++) {
      valorFinalBruto = valorFinalBruto * (1 + taxaMensal);
      valorFinalBruto += aporteMensal;
      totalAportes += aporteMensal;
    }

    double lucroBruto = valorFinalBruto - totalAportes;
    double impostoPago = lucroBruto * aliquotaIR;
    double valorFinalLiquido = valorFinalBruto - impostoPago;
    double lucroLiquido = valorFinalLiquido - totalAportes;

    return Investimento(
      tipo: tipoInvestimento,
      valorInicial: valorInicial,
      aporteMensal: aporteMensal,
      prazoMeses: prazoMeses,
      taxaJurosAnual: taxaJurosAnual,
      valorFinalBruto: valorFinalBruto,
      valorFinalLiquido: valorFinalLiquido,
      totalAportes: totalAportes,
      lucroBruto: lucroBruto,
      lucroLiquido: lucroLiquido,
      impostoPago: impostoPago,
      aliquotaIR: aliquotaIR * 100,
      rendimentoPercentual: totalAportes > 0
          ? ((valorFinalLiquido / totalAportes) - 1) * 100
          : 0.0,
      dataSimulacao: DateTime.now(),
    );
  }

  static Future<Map<String, double>> getTaxasAtuais() async {
    double selic = await _obterSelicAtual();
    return {
      'CDB': selic,
      'Tesouro Direto': selic,
      'LCA': selic * 0.90,
      'LCI': selic * 0.90,
      'Fundos de Investimento': selic * 0.95,
      'Ações': 12.0,
      'Poupança': selic > 8.5 ? 6.17 : selic * 0.70,
    };
  }

  static Future<List<String>> getTiposInvestimento() async {
    return [
      'CDB',
      'Tesouro Direto',
      'LCA',
      'LCI',
      'Fundos de Investimento',
      'Ações',
      'Poupança',
    ];
  }
}
