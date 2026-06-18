class Investimento {
  final String id;
  final String tipo;
  final double valorInicial;
  final double aporteMensal;
  final int prazoMeses;
  final double taxaJurosAnual;
  final double valorFinalBruto;
  final double valorFinalLiquido;
  final double totalAportes;
  final double lucroBruto;
  final double lucroLiquido;
  final double impostoPago;
  final double aliquotaIR;
  final double rendimentoPercentual;
  final DateTime dataSimulacao;

  Investimento({
    this.id = '',
    required this.tipo,
    required this.valorInicial,
    required this.aporteMensal,
    required this.prazoMeses,
    required this.taxaJurosAnual,
    required this.valorFinalBruto,
    required this.valorFinalLiquido,
    required this.totalAportes,
    required this.lucroBruto,
    required this.lucroLiquido,
    required this.impostoPago,
    required this.aliquotaIR,
    required this.rendimentoPercentual,
    required this.dataSimulacao,
  });

  factory Investimento.fromJson(Map<String, dynamic> json) {
    return Investimento(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      tipo: json['tipoInvestimento'] ?? json['tipo'] ?? '',
      valorInicial: (json['valorInicial'] as num).toDouble(),
      aporteMensal: (json['aporteMensal'] as num).toDouble(),
      prazoMeses: json['prazoMeses'] as int,
      taxaJurosAnual: (json['taxaJurosAnual'] as num).toDouble(),
      valorFinalBruto: (json['valorFinalBruto'] as num).toDouble(),
      valorFinalLiquido: (json['valorFinalLiquido'] as num).toDouble(),
      totalAportes: (json['totalAportes'] as num).toDouble(),
      lucroBruto: (json['lucroBruto'] as num).toDouble(),
      lucroLiquido: (json['lucroLiquido'] as num).toDouble(),
      impostoPago: (json['impostoPago'] as num).toDouble(),
      aliquotaIR: (json['aliquotaIR'] as num).toDouble(),
      rendimentoPercentual: (json['rendimentoPercentual'] as num).toDouble(),
      dataSimulacao: DateTime.parse(json['dataSimulacao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'valorInicial': valorInicial,
      'aporteMensal': aporteMensal,
      'prazoMeses': prazoMeses,
      'taxaJurosAnual': taxaJurosAnual,
      'valorFinalBruto': valorFinalBruto,
      'valorFinalLiquido': valorFinalLiquido,
      'totalAportes': totalAportes,
      'lucroBruto': lucroBruto,
      'lucroLiquido': lucroLiquido,
      'impostoPago': impostoPago,
      'aliquotaIR': aliquotaIR,
      'rendimentoPercentual': rendimentoPercentual,
      'dataSimulacao': dataSimulacao.toIso8601String(),
    };
  }

  Investimento copyWith({
    String? id,
    String? tipo,
    double? valorInicial,
    double? aporteMensal,
    int? prazoMeses,
    double? taxaJurosAnual,
    double? valorFinalBruto,
    double? valorFinalLiquido,
    double? totalAportes,
    double? lucroBruto,
    double? lucroLiquido,
    double? impostoPago,
    double? aliquotaIR,
    double? rendimentoPercentual,
    DateTime? dataSimulacao,
  }) {
    return Investimento(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      valorInicial: valorInicial ?? this.valorInicial,
      aporteMensal: aporteMensal ?? this.aporteMensal,
      prazoMeses: prazoMeses ?? this.prazoMeses,
      taxaJurosAnual: taxaJurosAnual ?? this.taxaJurosAnual,
      valorFinalBruto: valorFinalBruto ?? this.valorFinalBruto,
      valorFinalLiquido: valorFinalLiquido ?? this.valorFinalLiquido,
      totalAportes: totalAportes ?? this.totalAportes,
      lucroBruto: lucroBruto ?? this.lucroBruto,
      lucroLiquido: lucroLiquido ?? this.lucroLiquido,
      impostoPago: impostoPago ?? this.impostoPago,
      aliquotaIR: aliquotaIR ?? this.aliquotaIR,
      rendimentoPercentual: rendimentoPercentual ?? this.rendimentoPercentual,
      dataSimulacao: dataSimulacao ?? this.dataSimulacao,
    );
  }

  String get prazoFormatado {
    int anos = prazoMeses ~/ 12;
    int meses = prazoMeses % 12;
    if (anos > 0 && meses > 0) {
      return '$anos anos e $meses meses';
    } else if (anos > 0) {
      return '$anos anos';
    } else {
      return '$meses meses';
    }
  }

  String get valorFinalFormatado => 'R\$ ${valorFinalLiquido.toStringAsFixed(2)}';
  String get lucroFormatado => 'R\$ ${lucroLiquido.toStringAsFixed(2)}';
  String get rendimentoFormatado => '${rendimentoPercentual.toStringAsFixed(2)}%';
  
  bool get temLucro => lucroLiquido > 0;
  Color get corLucro => temLucro ? Colors.green : Colors.red;
}