class Categoria {
  int? id;
  String nome;
  String tipo;
  String observacoes;

  Categoria({
    this.id,
    required this.nome,
    required this.tipo,
    this.observacoes = '',
  });

  factory Categoria.fromMap(Map<String, dynamic> map) => Categoria(
        id: map['id'],
        nome: map['nome'],
        tipo: map['tipo'],
        observacoes: map['observacoes'] ?? '',
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nome': nome,
      'tipo': tipo,
      'observacoes': observacoes,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
