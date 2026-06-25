import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        'fotoUrl': '', // Adicionado campo fotoUrl
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

  static Future<bool> loginComGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            '611709619163-4jiak51eagmllru59rak9humgflnqcjp.apps.googleusercontent.com',
      );

      final GoogleSignInAccount? usuarioGoogle = await googleSignIn.signIn();
      if (usuarioGoogle == null) return false;

      final GoogleSignInAuthentication googleAuth =
          await usuarioGoogle.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // SALVANDO OS DADOS NO FIRESTORE
      if (userCredential.user != null) {
        final user = userCredential.user!;
        final docRef =
            FirebaseFirestore.instance.collection('usuarios').doc(user.uid);

        final docSnapshot = await docRef.get();

        // Se o documento não existir, criamos com os dados do Google
        if (!docSnapshot.exists) {
          await docRef.set({
            'nome': user.displayName ?? "Usuário Google",
            'email': user.email ?? "",
            'fotoUrl': user.photoURL ?? "", // SALVA A URL DA FOTO
            'dataCadastro': Timestamp.now(),
          });
        } else {
          // ATUALIZA A FOTO CASO O USUÁRIO JÁ EXISTA
          await docRef.update({
            'fotoUrl': user.photoURL ?? "",
            'nome': user.displayName ?? "Usuário Google",
          });
        }
      }

      return userCredential.user != null;
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
