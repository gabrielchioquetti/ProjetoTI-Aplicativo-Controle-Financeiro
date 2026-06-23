import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_projeto_ti/models/investimento.dart';

class InvestimentoService {
  // Salvar investimento no Firestore
  static Future<void> salvar(Investimento investimento) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception("Usuário não logado");
    }

    await FirebaseFirestore.instance.collection("investimentos").add({
      "uidUsuario": usuario.uid,
      "tipo": investimento.tipo,
      "valorInicial": investimento.valorInicial,
      "aporteMensal": investimento.aporteMensal,
      "prazoMeses": investimento.prazoMeses,
      "taxaJurosAnual": investimento.taxaJurosAnual,
      "valorFinalBruto": investimento.valorFinalBruto,
      "valorFinalLiquido": investimento.valorFinalLiquido,
      "totalAportes": investimento.totalAportes,
      "lucroBruto": investimento.lucroBruto,
      "lucroLiquido": investimento.lucroLiquido,
      "impostoPago": investimento.impostoPago,
      "aliquotaIR": investimento.aliquotaIR,
      "rendimentoPercentual": investimento.rendimentoPercentual,
      "dataSimulacao": Timestamp.fromDate(investimento.dataSimulacao),
      "criadoEm": Timestamp.now(),
    });
  }

  // Listar investimentos do usuário
  static Stream<QuerySnapshot> listar() {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return Stream.error("Usuário não logado");
    }

    return FirebaseFirestore.instance
        .collection("investimentos")
        .where("uidUsuario", isEqualTo: usuario.uid)
        .orderBy("dataSimulacao", descending: true)
        .snapshots();
  }

  // Excluir investimento
  static Future<void> excluir(String id) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception("Usuário não logado");
    }

    await FirebaseFirestore.instance
        .collection("investimentos")
        .doc(id)
        .delete();
  }

  // Buscar investimento por ID
  static Future<Investimento> buscarPorId(String id) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception("Usuário não logado");
    }

    final doc = await FirebaseFirestore.instance
        .collection("investimentos")
        .doc(id)
        .get();

    if (!doc.exists) {
      throw Exception("Investimento não encontrado");
    }

    final dados = doc.data() as Map<String, dynamic>;

    // Converter Timestamp para DateTime
    final timestamp = dados['dataSimulacao'] as Timestamp;
    dados['dataSimulacao'] = timestamp.toDate().toIso8601String();

    return Investimento.fromJson(dados);
  }
}
