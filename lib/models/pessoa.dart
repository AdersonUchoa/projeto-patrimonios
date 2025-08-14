class Pessoa {
  int? id;
  String nome;
  String? email;
  String? telefone;

  Pessoa({
    this.id,
    required this.nome,
    this.email,
    this.telefone,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nome': nome,
      'email': email,
      'telefone': telefone,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      email: map['email'] as String?,
      telefone: map['telefone'] as String?,
    );
  }
}
