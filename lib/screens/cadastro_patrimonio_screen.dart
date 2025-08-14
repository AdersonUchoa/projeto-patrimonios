import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CadastroPatrimonioScreen extends StatefulWidget {
  const CadastroPatrimonioScreen({super.key});

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

  String? _categoriaSelecionada;
  String? _responsavelSelecionado;
  String? _localizacaoSelecionada;
  DateTime? _dataSelecionada;

  @override
  void dispose() {
    _codigoController.dispose();
    _nomeItemController.dispose();
    _valorController.dispose();
    _descricaoController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      print('Código: ${_codigoController.text}');
      print('Nome: ${_nomeItemController.text}');
      print('Categoria: $_categoriaSelecionada');
      print('Valor: ${_valorController.text}');
      print('Data aquisição: ${_dataController.text}');
      print('Responsável: $_responsavelSelecionado');
      print('Localização: $_localizacaoSelecionada');
      print('Descrição: ${_descricaoController.text}');

      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Novo item do patrimônio',
          style: TextStyle(color: Colors.black),
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
            children: [
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Código do patrimônio *',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'O código é obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeItemController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome do item *',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'O nome é obrigatório' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Categoria *',
                  border: OutlineInputBorder(),
                ),
                value: _categoriaSelecionada,
                items: const [
                  DropdownMenuItem(value: 'Móveis', child: Text('Móveis')),
                  DropdownMenuItem(
                    value: 'Eletrônicos',
                    child: Text('Eletrônicos'),
                  ),
                  DropdownMenuItem(value: 'Outros', child: Text('Outros')),
                ],
                onChanged: (value) => setState(() {
                  _categoriaSelecionada = value;
                }),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Selecione uma categoria' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Valor estimado *',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'O valor é obrigatório' : null,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dataController,
                decoration: const InputDecoration(
                  labelText: 'Data de aquisição *',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: _selecionarData,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Selecione a data' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Pessoa responsável (opcional)',
                  border: OutlineInputBorder(),
                ),
                value: _responsavelSelecionado,
                items: const [
                  DropdownMenuItem(value: 'Aluno', child: Text('Aluno')),
                  DropdownMenuItem(
                    value: 'Professor',
                    child: Text('Professor'),
                  ),
                  DropdownMenuItem(
                    value: 'Funcionário',
                    child: Text('Funcionário'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _responsavelSelecionado = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Localização (opcional)',
                  border: OutlineInputBorder(),
                ),
                value: _localizacaoSelecionada,
                items: const [
                  DropdownMenuItem(value: 'Sala 1', child: Text('Sala 1')),
                  DropdownMenuItem(value: 'Sala 2', child: Text('Sala 2')),
                  DropdownMenuItem(value: 'Depósito', child: Text('Depósito')),
                ],
                onChanged: (value) =>
                    setState(() => _localizacaoSelecionada = value),
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
                maxLines: null,
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
                                              backgroundColor: Colors.white10,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancelar', style: TextStyle(color: Colors.white, fontSize: 16),),
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
