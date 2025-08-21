import 'package:flutter/material.dart';
import 'package:patrimonios/db/database_helper.dart';
import 'package:patrimonios/models/categoria.dart';

class CadastroCategoriaScreen extends StatefulWidget {
  final Categoria? categoria;

  const CadastroCategoriaScreen({super.key, this.categoria});

  @override
  State<CadastroCategoriaScreen> createState() =>
      _CadastroCategoriaScreenState();
}

class _CadastroCategoriaScreenState extends State<CadastroCategoriaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _observacoesController = TextEditingController();
  String? _tipoSelecionado;

  @override
  void initState() {
    super.initState();

    if (widget.categoria != null) {
      _nomeController.text = widget.categoria!.nome;
      _tipoSelecionado = widget.categoria!.tipo;
      _observacoesController.text = widget.categoria!.observacoes;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final categoria = Categoria(
        id: widget.categoria?.id,
        nome: _nomeController.text.trim(),
        tipo: _tipoSelecionado!,
        observacoes: _observacoesController.text.trim(),
      );

      try {
        if (widget.categoria == null) {
          await DatabaseHelper.instance.inserirCategoria(categoria);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Categoria cadastrada com sucesso')),
          );
        } else {
          await DatabaseHelper.instance.atualizarCategoria(categoria);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Categoria atualizada com sucesso')),
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

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.categoria != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Categoria' : 'Nova Categoria',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                  hintText: 'Digite o nome da categoria',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo *',
                  border: OutlineInputBorder(),
                ),
                value: _tipoSelecionado,
                items: const [
                  DropdownMenuItem(value: 'Móveis', child: Text('Móveis')),
                  DropdownMenuItem(value: 'Eletrônicos', child: Text('Eletrônicos')),
                  DropdownMenuItem(value: 'Informática', child: Text('Informática')),
                  DropdownMenuItem(value: 'Veículos', child: Text('Veículos')),
                  DropdownMenuItem(value: 'Equipamentos', child: Text('Equipamentos')),
                  DropdownMenuItem(value: 'Imóveis', child: Text('Imóveis')),
                  DropdownMenuItem(value: 'Ferramentas', child: Text('Ferramentas')),
                  DropdownMenuItem(value: 'Livros', child: Text('Livros')),
                  DropdownMenuItem(value: 'Máquinas', child: Text('Máquinas')),
                  DropdownMenuItem(value: 'Outros', child: Text('Outros')),
                ],
                onChanged: (value) {
                  setState(() {
                    _tipoSelecionado = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione um tipo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _observacoesController,
                decoration: const InputDecoration(
                  labelText: 'Observações',
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