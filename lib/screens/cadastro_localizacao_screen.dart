import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/localizacao.dart';

class CadastroLocalizacaoScreen extends StatefulWidget {
  final Localizacao? localizacao;

  const CadastroLocalizacaoScreen({super.key, this.localizacao});

  @override
  State<CadastroLocalizacaoScreen> createState() =>
      _CadastroLocalizacaoScreenState();
}

class _CadastroLocalizacaoScreenState extends State<CadastroLocalizacaoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.localizacao != null) {
      _nomeController.text = widget.localizacao!.nome;
      _enderecoController.text = widget.localizacao!.endereco;
      _observacoesController.text = widget.localizacao!.observacoes;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _enderecoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  // AQUI ESTÁ A MUDANÇA PRINCIPAL
  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final localizacaoParaSalvar = Localizacao(
        id: widget.localizacao?.id,
        nome: _nomeController.text,
        endereco: _enderecoController.text,
        observacoes: _observacoesController.text,
      );

      if (widget.localizacao == null) {
        await DatabaseHelper.instance.inserirLocalizacao(localizacaoParaSalvar);
      } else {
        await DatabaseHelper.instance.atualizarLocalizacao(localizacaoParaSalvar);
      }
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.localizacao == null ? 'Nova Localização' : 'Editar Localização',
          style: const TextStyle(color: Colors.black),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome *',
                  hintText: 'Digite o nome da localização',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Endereço',
                  hintText: 'Digite o endereço',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _observacoesController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Digite uma descrição (opcional)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
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