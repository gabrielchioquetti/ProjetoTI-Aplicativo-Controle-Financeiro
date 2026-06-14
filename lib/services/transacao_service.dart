// services/transacao_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransacaoService {
  // MÉTODO: Salvar nova transação
  static Future<void> salvar({
    required String descricao,
    required double valor,
    required String categoria,
    required DateTime data,
    required bool entrada,
  }) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception("Usuário não logado");
    }

    await FirebaseFirestore.instance.collection("transacoes").add({
      "uidUsuario": usuario.uid,
      "descricao": descricao,
      "valor": valor,
      "categoria": categoria,
      "entrada": entrada,
      "data": Timestamp.fromDate(data),
      "criadoEm": Timestamp.now(),
    });
  }

  // MÉTODO: Listar transações do usuário
  static Stream<QuerySnapshot> listar() {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return Stream.error("Usuário não logado");
    }

    return FirebaseFirestore.instance
        .collection("transacoes")
        .where("uidUsuario", isEqualTo: usuario.uid)
        .orderBy("data", descending: true)
        .snapshots();
  }

  // MÉTODO: Atualizar transação existente
  static Future<void> atualizar({
    required String id,
    required String descricao,
    required double valor,
    required String categoria,
    required DateTime data,
    required bool entrada,
  }) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception("Usuário não logado");
    }

    // Verificar se a transação pertence ao usuário
    final doc =
        await FirebaseFirestore.instance.collection("transacoes").doc(id).get();

    if (!doc.exists) {
      throw Exception("Transação não encontrada");
    }

    final dados = doc.data() as Map<String, dynamic>;
    if (dados['uidUsuario'] != usuario.uid) {
      throw Exception("Você não tem permissão para editar esta transação");
    }

    // Atualizar a transação
    await FirebaseFirestore.instance.collection("transacoes").doc(id).update({
      "descricao": descricao,
      "valor": valor,
      "categoria": categoria,
      "entrada": entrada,
      "data": Timestamp.fromDate(data),
      "atualizadoEm": Timestamp.now(),
    });
  }

  // MÉTODO: Excluir transação
  static Future<void> excluir(String id) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception("Usuário não logado");
    }

    // Verificar se a transação pertence ao usuário
    final doc =
        await FirebaseFirestore.instance.collection("transacoes").doc(id).get();

    if (!doc.exists) {
      throw Exception("Transação não encontrada");
    }

    final dados = doc.data() as Map<String, dynamic>;
    if (dados['uidUsuario'] != usuario.uid) {
      throw Exception("Você não tem permissão para excluir esta transação");
    }

    // Excluir a transação
    await FirebaseFirestore.instance.collection("transacoes").doc(id).delete();
  }

  // MÉTODO EXTRA: Buscar uma transação específica
  static Future<Map<String, dynamic>> buscarPorId(String id) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception("Usuário não logado");
    }

    final doc =
        await FirebaseFirestore.instance.collection("transacoes").doc(id).get();

    if (!doc.exists) {
      throw Exception("Transação não encontrada");
    }

    final dados = doc.data() as Map<String, dynamic>;

    if (dados['uidUsuario'] != usuario.uid) {
      throw Exception("Você não tem permissão para acessar esta transação");
    }

    return {
      'id': doc.id,
      ...dados,
    };
  }

  // MÉTODO EXTRA: Buscar transações por período
  static Stream<QuerySnapshot> listarPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  }) {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return Stream.error("Usuário não logado");
    }

    return FirebaseFirestore.instance
        .collection("transacoes")
        .where("uidUsuario", isEqualTo: usuario.uid)
        .where("data", isGreaterThanOrEqualTo: Timestamp.fromDate(dataInicio))
        .where("data", isLessThanOrEqualTo: Timestamp.fromDate(dataFim))
        .orderBy("data", descending: true)
        .snapshots();
  }

  // MÉTODO EXTRA: Calcular saldo total
  static Future<double> calcularSaldoTotal() async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception("Usuário não logado");
    }

    final snapshot = await FirebaseFirestore.instance
        .collection("transacoes")
        .where("uidUsuario", isEqualTo: usuario.uid)
        .get();

    double saldo = 0;
    for (var doc in snapshot.docs) {
      final dados = doc.data();
      final valor = dados['valor'] as num;
      saldo += valor;
    }

    return saldo;
  }
}
