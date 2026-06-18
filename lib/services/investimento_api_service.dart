import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_projeto_ti/models/investimento.dart';

class InvestimentoApiService {

  static const String baseUrlBacen = 'https://api.bcb.gov.br';

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
      
      print('Taxa SELIC obtida: $taxaSelic%');
      print('Tipo de investimento: $tipo');

      if (tipo == 'cdb') {
        taxaFinal = taxaJurosAnual;
      } 
      else if (tipo == 'tesouro direto') {
        taxaFinal = taxaJurosAnual;
      } 
      else if (tipo == 'lca' || tipo == 'lci') {
        taxaFinal = taxaJurosAnual;
      } 
      else if (tipo == 'fundos de investimento' || tipo == 'fundos') {
        taxaFinal = taxaJurosAnual;
      } 
      else if (tipo == 'ações' || tipo == 'acoes') {
        taxaFinal = taxaJurosAnual > 0 ? taxaJurosAnual : 12.0;
      } 
      else if (tipo == 'poupança' || tipo == 'poupanca') {
        if (taxaSelic > 8.5) {
          taxaFinal = 6.17;
        } else {
          taxaFinal = 0.7 * taxaSelic;
        }
      } 
      else {
        taxaFinal = taxaJurosAnual;
      }
      
      print('Taxa final aplicada: $taxaFinal%');
      
      double aliquotaIR = _calcularAliquotaIR(tipo, prazoMeses);
      
      return _simularLocalmente(
        valorInicial: valorInicial,
        aporteMensal: aporteMensal,
        prazoMeses: prazoMeses,
        taxaJurosAnual: taxaFinal,
        tipoInvestimento: tipoInvestimento,
        aliquotaIR: aliquotaIR,
      );
      
    } catch (e) {
      print('Erro no fluxo principal da API, usando parâmetros locais: $e');
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

    if (tipo == 'poupança' || tipo == 'poupanca' || 
        tipo == 'lca' || tipo == 'lci') {
      return 0.0;
    }
    
    if (tipo == 'cdb' || tipo == 'tesouro direto' || 
        tipo == 'fundos de investimento' || tipo == 'fundos') {
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

  static Future<double> _obterSelicAtual() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrlBacen/dados/serie/bcdata.sgs.432/dados?formato=json'),
        headers: {'Accept': 'application/json'},
      );

      print('Chamando API do BACEN...');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> dados = jsonDecode(response.body);
        if (dados.isNotEmpty) {
          var ultimo = dados.last;
          String valorStr = ultimo['valor'].toString().replaceAll(',', '.');
          double selic = double.parse(valorStr);
          print('SELIC Meta obtida via API: $selic% a.a.');
          return selic;
        } else {
          print('Resposta da API vazia');
        }
      } else {
        print('API retornou status: ${response.statusCode}');
        print('Resposta: ${response.body}');
      }
    } catch (e) {
      print('Erro na requisição ao BACEN: $e');
    }
    
    print('Usando SELIC padrão: 10.75%');
    return 10.75;
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
    
    print('📊 Taxa mensal efetiva: ${(taxaMensal * 100).toStringAsFixed(4)}%');
    
    double valorFinalBruto = valorInicial;
    double totalAportes = valorInicial;

    for (int i = 0; i < prazoMeses; i++) {
      valorFinalBruto = valorFinalBruto * (1 + taxaMensal);
      valorFinalBruto += aporteMensal;
      totalAportes += aporteMensal;
      
      if ((i + 1) % 12 == 0) {
        print('Mês ${i + 1}: R\$ ${valorFinalBruto.toStringAsFixed(2)}');
      }
    }

    double lucroBruto = valorFinalBruto - totalAportes;
    
    // Aplicar IR
    double impostoPago = lucroBruto * aliquotaIR;
    double valorFinalLiquido = valorFinalBruto - impostoPago;
    double lucroLiquido = valorFinalLiquido - totalAportes;
    
    print('Valor final bruto: R\$ ${valorFinalBruto.toStringAsFixed(2)}');
    print('Valor final líquido: R\$ ${valorFinalLiquido.toStringAsFixed(2)}');
    print('Alíquota IR: ${(aliquotaIR * 100).toStringAsFixed(1)}%');
    print('Imposto pago: R\$ ${impostoPago.toStringAsFixed(2)}');
    
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
      rendimentoPercentual: totalAportes > 0 ? ((valorFinalLiquido / totalAportes) - 1) * 100 : 0.0,
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