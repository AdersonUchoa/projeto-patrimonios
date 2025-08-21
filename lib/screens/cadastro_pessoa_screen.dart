import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../db/database_helper.dart';

class CadastroPessoaScreen extends StatefulWidget {
  final Pessoa? pessoa;

  const CadastroPessoaScreen({super.key, this.pessoa});

  @override
  State<CadastroPessoaScreen> createState() => _CadastroPessoaScreenState();
}

class _CadastroPessoaScreenState extends State<CadastroPessoaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.pessoa?.nome ?? '');
    _emailController = TextEditingController(text: widget.pessoa?.email ?? '');
    _telefoneController = TextEditingController(
      text: widget.pessoa?.telefone ?? '',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final novaPessoa = Pessoa(
        id: widget.pessoa?.id,
        nome: _nomeController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        telefone: _telefoneController.text.isEmpty
            ? null
            : _telefoneController.text,
      );

      final dbHelper = DatabaseHelper.instance;

      if (widget.pessoa == null) {
        await dbHelper.inserirPessoa(novaPessoa);
      } else {
        await dbHelper.atualizarPessoa(novaPessoa);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pessoa == null ? 'Nova Pessoa' : 'Editar Pessoa',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome *',
                  hintText: 'Digite o nome da pessoa',
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
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Digite o email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Telefone',
                  hintText: 'Digite o telefone',
                ),
                keyboardType: TextInputType.phone,
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