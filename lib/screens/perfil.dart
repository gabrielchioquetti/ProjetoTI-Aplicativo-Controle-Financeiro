import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_projeto_ti/widgets/bottom_nav.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfil();
}

class _TelaPerfil extends State<TelaPerfil> {
  File? _imagemPerfilMobile;
  String? _imagemPerfilWeb;
  final ImagePicker _picker = ImagePicker();

  final User? usuarioAtual = FirebaseAuth.instance.currentUser;

  Future<void> _alterarFoto(ImageSource fonte) async {
    try {
      final XFile? arquivoSelecionado = await _picker.pickImage(
        source: fonte,
        imageQuality: 80,
      );

      if (arquivoSelecionado != null) {
        setState(() {
          if (kIsWeb) {
            _imagemPerfilWeb = arquivoSelecionado.path;
          } else {
            _imagemPerfilMobile = File(arquivoSelecionado.path);
          }
        });
      }
    } catch (e) {
      debugPrint("Erro ao selecionar imagem: $e");
    }
  }

  void _removerFoto() {
    setState(() {
      _imagemPerfilMobile = null;
      _imagemPerfilWeb = null;
    });
  }

  void _mostrarOpcoesFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text("Escolher da Galeria"),
                onTap: () {
                  Navigator.pop(context);
                  _alterarFoto(ImageSource.gallery);
                },
              ),
              // REMOVIDO O 'if (!kIsWeb)': Agora a opção sempre aparece
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text("Tirar Nova Foto"),
                onTap: () {
                  Navigator.pop(context);
                  _alterarFoto(ImageSource.camera);
                },
              ),
              if (_imagemPerfilMobile != null || _imagemPerfilWeb != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text("Remover Foto Atual",
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _removerFoto();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget itemMenu({
    required IconData icone,
    required String titulo,
    Color cor = Colors.black,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Icon(icone, color: cor),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              titulo,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: cor,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _construirImagemPerfil() {
    if (kIsWeb && _imagemPerfilWeb != null) {
      return Image.network(
        _imagemPerfilWeb!,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    } else if (!kIsWeb && _imagemPerfilMobile != null) {
      return Image.file(
        _imagemPerfilMobile!,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    }
    return const Icon(
      Icons.person,
      size: 40,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    String emailUsuario = usuarioAtual?.email ?? "sem-email@email.com";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// CARD PERFIL (Buscando o nome real do Firestore)
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('usuarios')
                    .doc(usuarioAtual?.uid)
                    .get(),
                builder: (context, snapshot) {
                  String nomeExibido = "Carregando...";

                  if (snapshot.hasData && snapshot.data!.exists) {
                    final dados = snapshot.data!.data() as Map<String, dynamic>;
                    nomeExibido = dados['nome'] ?? "Usuário";
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    // Fallback se não achar o documento com o UID do usuário
                    nomeExibido = emailUsuario.split('@')[0];
                  }

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        /// FOTO DINÂMICA
                        GestureDetector(
                          onTap: _mostrarOpcoesFoto,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.blue.shade900,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: _construirImagemPerfil(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        /// NOME DO FIRESTORE E EMAIL
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nomeExibido,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                emailUsuario,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// EDITAR FOTO
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: _mostrarOpcoesFoto,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              /// MENU
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    itemMenu(
                        icone: Icons.person_outline, titulo: "Dados Pessoais"),
                    itemMenu(icone: Icons.shield_outlined, titulo: "Segurança"),
                    itemMenu(
                        icone: Icons.notifications_none,
                        titulo: "Notificações"),
                    itemMenu(
                        icone: Icons.flag_outlined, titulo: "Meus Objetivos"),
                    itemMenu(
                        icone: Icons.help_outline, titulo: "Central de Ajuda"),
                    itemMenu(icone: Icons.info_outline, titulo: "Sobre o App"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// SAIR
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Sair da conta",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/",
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(paginaAtual: 3),
    );
  }
}
