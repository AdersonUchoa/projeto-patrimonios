class Localizacao {
  int? id;
  String nome;
  String endereco;
  String observacoes;

  Localizacao({
    this.id,
    required this.nome,
    required this.endereco,
    required this.observacoes,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nome': nome,
      'endereco': endereco,
      'observacoes': observacoes,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Localizacao.fromMap(Map<String, dynamic> map) {
    return Localizacao(
      id: map['id'],
      nome: map['nome'],
      endereco: map['endereco'],
      observacoes: map['observacoes'],
    );
  }
}