import 'package:flutter/material.dart';

import 'package:flutter_projeto_ti/widgets/bottom_nav.dart';

class TelaPerfil extends StatefulWidget {
  @override
  State<TelaPerfil> createState() => _TelaPerfil();
}

class _TelaPerfil extends State<TelaPerfil> {
  Widget itemMenu({
    required IconData icone,
    required String titulo,
    Color cor = Colors.black,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),

      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),

      child: Row(
        children: [
          Icon(icone, color: cor),

          SizedBox(width: 16),

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

          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),

          child: Column(
            children: [
              /// CARD PERFIL
              Container(
                padding: EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.blue.shade700,

                  borderRadius: BorderRadius.circular(24),
                ),

                child: Row(
                  children: [
                    /// FOTO
                    CircleAvatar(
                      radius: 35,

                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/300",
                      ),
                    ),

                    SizedBox(width: 16),

                    /// NOME
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Gabriel Silva",

                            style: TextStyle(
                              color: Colors.white,

                              fontSize: 22,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "gabriel.silva@email.com",

                            style: TextStyle(
                              color: Colors.white70,

                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// EDITAR
                    Icon(Icons.edit, color: Colors.white),
                  ],
                ),
              ),

              SizedBox(height: 20),

              /// MENU
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  children: [
                    itemMenu(
                      icone: Icons.person_outline,
                      titulo: "Dados Pessoais",
                    ),

                    itemMenu(icone: Icons.shield_outlined, titulo: "Segurança"),

                    itemMenu(
                      icone: Icons.notifications_none,
                      titulo: "Notificações",
                    ),

                    itemMenu(
                      icone: Icons.flag_outlined,
                      titulo: "Meus Objetivos",
                    ),

                    itemMenu(
                      icone: Icons.help_outline,
                      titulo: "Central de Ajuda",
                    ),

                    itemMenu(icone: Icons.info_outline, titulo: "Sobre o App"),
                  ],
                ),
              ),

              SizedBox(height: 20),

              /// SAIR
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(16),
                ),

                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),

                  title: Text(
                    "Sair da conta",

                    style: TextStyle(
                      color: Colors.red,

                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  onTap: () {
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

      bottomNavigationBar: BottomNavWidget(paginaAtual: 3),
    );
  }
}
