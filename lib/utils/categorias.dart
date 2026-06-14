import 'package:flutter/material.dart';

class Categoria {
  final String nome;
  final IconData icone;
  
  const Categoria({required this.nome, required this.icone});
  
  static const List<Categoria> todas = [
    Categoria(nome: "Alimentação", icone: Icons.restaurant),
    Categoria(nome: "Transporte", icone: Icons.directions_car),
    Categoria(nome: "Lazer", icone: Icons.movie),
    Categoria(nome: "Saúde", icone: Icons.health_and_safety),
    Categoria(nome: "Educação", icone: Icons.school),
    Categoria(nome: "Moradia", icone: Icons.house),
    Categoria(nome: "Salário", icone: Icons.attach_money),
    Categoria(nome: "Outros", icone: Icons.category),
  ];
  
  static List<String> get nomes => todas.map((c) => c.nome).toList();
}