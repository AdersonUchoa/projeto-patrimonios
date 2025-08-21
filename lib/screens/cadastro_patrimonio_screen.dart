import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patrimonios/db/database_helper.dart';
import 'package:patrimonios/models/patrimonio.dart';
import 'package:patrimonios/models/categoria.dart';
import 'package:patrimonios/models/localizacao.dart';
import 'package:patrimonios/models/pessoa.dart';

class CadastroPatrimonioScreen extends StatefulWidget {
  final Patrimonio? patrimonio;

  const CadastroPatrimonioScreen({super.key, this.patrimonio});

  @override
  State<CadastroPatrimonioScreen> createState() =>
      _CadastroPatrimonioScreenState();
}

class _CadastroPatrimonioScreenState extends State<CadastroPatrimonioScreen> {
  final _formKey = GlobalKey<FormState>();

  final _codigoController = TextEditingController();
  final _nomeItemController = TextEditingController();
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _dataController = TextEditingController();

  int? _categoriaSelecionada;
  int? _responsavelSelecionado;
  int? _localizacaoSelecionada;
  DateTime? _dataSelecionada;

  Future<List<Categoria>>? _categoriasFuture;
  Future<List<Pessoa>>? _pessoasFuture;
  Future<List<Localizacao>>? _localizacoesFuture;

  @override
  void initState() {
    super.initState();
    _carregarDados();
    _preencherFormulario();
  }

  void _carregarDados() {
    _categoriasFuture = DatabaseHelper.instance.listarCategorias();
    _pessoasFuture = DatabaseHelper.instance.listarPessoas();
    _localizacoesFuture = DatabaseHelper.instance.listarLocalizacoes();
  }

  void _preencherFormulario() {
    if (widget.patrimonio != null) {
      final patrimonio = widget.patrimonio!;
      _codigoController.text = patrimonio.codigo;
      _nomeItemController.text = patrimonio.nome;
      _valorController.text = patrimonio.valor.toStringAsFixed(2).replaceAll('.', ',');
      _descricaoController.text = patrimonio.descricao;
      _categoriaSelecionada = patrimonio.categoriaId;
      _responsavelSelecionado = patrimonio.pessoaId;
      _localizacaoSelecionada = patrimonio.localizacaoId;

      // Converter a data de string para DateTime
      try {
        _dataSelecionada = DateTime.parse(patrimonio.dataAquisicao);
        _dataController.text = DateFormat('dd/MM/yyyy').format(_dataSelecionada!);
      } catch (e) {
        // Se a data já estiver no formato dd/MM/yyyy
        _dataController.text = patrimonio.dataAquisicao;
        try {
          final parts = patrimonio.dataAquisicao.split('/');
          if (parts.length == 3) {
            _dataSelecionada = DateTime(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );
          }
        } catch (e) {
          // Se não conseguir converter, use a data atual
          _dataSelecionada = DateTime.now();
        }
      }
    }
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nomeItemController.dispose();
    _valorController.dispose();
    _descricaoController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Converter o valor de string para double
        final valorString = _valorController.text.replaceAll(',', '.');
        final valor = double.parse(valorString);

        // Converter a data para formato ISO
        String dataFormatada;
        if (_dataSelecionada != null) {
          dataFormatada = _dataSelecionada!.toIso8601String().split('T')[0];
        } else {
          dataFormatada = DateTime.now().toIso8601String().split('T')[0];
        }

        final patrimonio = Patrimonio(
          id: widget.patrimonio?.id,
          codigo: _codigoController.text.trim(),
          nome: _nomeItemController.text.trim(),
          categoriaId: _categoriaSelecionada,
          pessoaId: _responsavelSelecionado,
          localizacaoId: _localizacaoSelecionada,
          dataAquisicao: dataFormatada,
          valor: valor,
          descricao: _descricaoController.text.trim(),
        );

        if (widget.patrimonio == null) {
          await DatabaseHelper.instance.inserirPatrimonio(patrimonio);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Patrimônio cadastrado com sucesso')),
          );
        } else {
          await DatabaseHelper.instance.atualizarPatrimonio(patrimonio);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Patrimônio atualizado com sucesso')),
          );
        }

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
  }

  Future<void> _selecionarData() async {
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (data != null) {
      setState(() {
        _dataSelecionada = data;
        _dataController.text = DateFormat('dd/MM/yyyy').format(data);
      });
    }
  }

  String? _validarValor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O valor é obrigatório';
    }
    
    final valorString = value.replaceAll(',', '.');
    final valor = double.tryParse(valorString);
    
    if (valor == null || valor <= 0) {
      return 'Digite um valor válido';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.patrimonio != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Editar Patrimônio' : 'Novo item do patrimônio',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Código do patrimônio *',
                  hintText: 'Digite o código único do item',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'O código é obrigatório' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nomeItemController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome do item *',
                  hintText: 'Digite o nome do item',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'O nome é obrigatório' : null,
              ),
              const SizedBox(height: 16),
              
              FutureBuilder<List<Categoria>>(
                future: _categoriasFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Categoria *',
                        border: OutlineInputBorder(),
                      ),
                      items: const [],
                      onChanged: null,
                    );
                  }
                  
                  final categorias = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Categoria *',
                      border: OutlineInputBorder(),
                    ),
                    value: _categoriaSelecionada,
                    items: categorias.map((categoria) {
                      return DropdownMenuItem<int>(
                        value: categoria.id,
                        child: Text(categoria.nome),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {
                      _categoriaSelecionada = value;
                    }),
                    validator: (v) =>
                        v == null ? 'Selecione uma categoria' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Valor estimado *',
                  hintText: 'Ex: 1500,00',
                  prefixText: 'R\$ ',
                ),
                validator: _validarValor,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                ],
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _dataController,
                decoration: const InputDecoration(
                  labelText: 'Data de aquisição *',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selecionarData,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Selecione a data' : null,
              ),
              const SizedBox(height: 16),
              
              FutureBuilder<List<Pessoa>>(
                future: _pessoasFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Pessoa responsável (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      items: const [],
                      onChanged: null,
                    );
                  }
                  
                  final pessoas = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Pessoa responsável (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    value: _responsavelSelecionado,
                    items: pessoas.map((pessoa) {
                      return DropdownMenuItem<int>(
                        value: pessoa.id,
                        child: Text(pessoa.nome),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _responsavelSelecionado = value),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              FutureBuilder<List<Localizacao>>(
                future: _localizacoesFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Localização (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      items: const [],
                      onChanged: null,
                    );
                  }
                  
                  final localizacoes = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Localização (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    value: _localizacaoSelecionada,
                    items: localizacoes.map((localizacao) {
                      return DropdownMenuItem<int>(
                        value: localizacao.id,
                        child: Text(localizacao.nome),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _localizacaoSelecionada = value),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Digite informações adicionais',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _salvar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}