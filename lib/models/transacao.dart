class Transacao {

  String titulo;
  double valor;
  String categoria;
  DateTime data;
  bool entrada;

  Transacao({
    required this.titulo,
    required this.valor,
    required this.categoria,
    required this.data,
    required this.entrada,
  });
}