import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Salva a imagem como Base64 no documento do usuário
  Future<void> salvarFotoBase64(File imagem) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    Uint8List bytes = await imagem.readAsBytes();
    String base64Image = base64Encode(bytes);

    await _firestore.collection('usuarios').doc(uid).update({
      'fotoBase64': base64Image,
    });
  }

  // Busca a string Base64 do Firestore e converte para Bytes
  Future<Uint8List?> carregarFotoBase64() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    DocumentSnapshot doc =
        await _firestore.collection('usuarios').doc(uid).get();
    Map<String, dynamic>? dados = doc.data() as Map<String, dynamic>?;

    if (dados != null && dados.containsKey('fotoBase64')) {
      return base64Decode(dados['fotoBase64']);
    }

    return null;
  }
}
