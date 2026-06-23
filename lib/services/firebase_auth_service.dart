import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      UserCredential credencial = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(credencial.user!.uid)
          .set({
        'nome': nome,
        'email': email,
        'dataCadastro': Timestamp.now(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> login({
    required String email,
    required String senha,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static User? get usuarioAtual {
    return _auth.currentUser;
  }
}
