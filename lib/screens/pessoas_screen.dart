import 'package:flutter/material.dart';
import 'package:patrimonios/widgets/empty_state.dart';
import '../db/database_helper.dart';
import '../models/pessoa.dart';
import 'cadastro_pessoa_screen.dart';

class PessoasScreen extends StatefulWidget {
  const PessoasScreen({super.key});

  @override
  State<PessoasScreen> createState() => _PessoasScreenState();
}

class _PessoasScreenState extends State<PessoasScreen> {
  List<Pessoa> pessoas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPessoas();
  }

  Future<void> _carregarPessoas() async {
    setState(() {
      carregando = true;
    });
    final dbHelper = DatabaseHelper.instance;
    final lista = await dbHelper.listarPessoas();
    setState(() {
      pessoas = lista;
      carregando = false;
    });
  }

  void _abrirCadastroPessoa({Pessoa? pessoa}) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroPessoaScreen(pessoa: pessoa),
      ),
    );
    if (resultado == true) {
      _carregarPessoas();
    }
  }

  Future<void> _excluirPessoa(int id) async {
    final dbHelper = DatabaseHelper.instance;
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Deseja realmente excluir esta pessoa?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Excluir'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      await dbHelper.deletarPessoa(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pessoa excluída com sucesso')),
      );
      _carregarPessoas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pessoas',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () => _abrirCadastroPessoa(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Adicionar',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : pessoas.isEmpty
          ? EmptyState(
              icon: Icons.people_outline,
              title: 'Nenhuma pessoa cadastrada',
              buttonText: 'Adicionar primeira pessoa',
              onPressed: () => _abrirCadastroPessoa(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pessoas.length,
              itemBuilder: (context, index) {
                final pessoa = pessoas[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.green),
                    title: Text(pessoa.nome),
                    subtitle: Text(
                      [
                        if (pessoa.email != null && pessoa.email!.isNotEmpty)
                          pessoa.email,
                        if (pessoa.telefone != null &&
                            pessoa.telefone!.isNotEmpty)
                          pessoa.telefone,
                      ].whereType<String>().join(' • '),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: 'Editar',
                          onPressed: () => _abrirCadastroPessoa(pessoa: pessoa),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Excluir',
                          onPressed: () => _excluirPessoa(pessoa.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}