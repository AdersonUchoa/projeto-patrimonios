class Patrimonio {
  int? id;
  String codigo;
  String nome;
  int? categoriaId;
  int? localizacaoId;
  int? pessoaId;
  String dataAquisicao;
  double valor;
  String descricao;

  String? nomeCategoria;
  String? nomeLocalizacao;
  String? nomePessoa;

  Patrimonio({
    this.id,
    required this.codigo,
    required this.nome,
    this.categoriaId,
    this.localizacaoId,
    this.pessoaId,
    required this.dataAquisicao,
    required this.valor,
    this.descricao = '',
    this.nomeCategoria,
    this.nomeLocalizacao,
    this.nomePessoa,
  });

  factory Patrimonio.fromMap(Map<String, dynamic> map) => Patrimonio(
        id: map['id'],
        codigo: map['codigo'],
        nome: map['nome'],
        categoriaId: map['categoria_id'],
        localizacaoId: map['localizacao_id'],
        pessoaId: map['pessoa_id'],
        dataAquisicao: map['data_aquisicao'],
        valor: map['valor']?.toDouble() ?? 0.0,
        descricao: map['descricao'] ?? '',
        nomeCategoria: map['nome_categoria'],
        nomeLocalizacao: map['nome_localizacao'],
        nomePessoa: map['nome_pessoa'],
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'codigo': codigo,
      'nome': nome,
      'categoria_id': categoriaId,
      'localizacao_id': localizacaoId,
      'pessoa_id': pessoaId,
      'data_aquisicao': dataAquisicao,
      'valor': valor,
      'descricao': descricao,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}