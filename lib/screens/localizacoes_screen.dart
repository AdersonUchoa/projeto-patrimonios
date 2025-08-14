import 'package:flutter/material.dart';
import 'package:patrimonios/widgets/empty_state.dart';
import '../db/database_helper.dart';
import '../models/localizacao.dart';
import 'cadastro_localizacao_screen.dart';

class LocalizacoesScreen extends StatefulWidget {
  const LocalizacoesScreen({super.key});

  @override
  State<LocalizacoesScreen> createState() => _LocalizacoesScreenState();
}

class _LocalizacoesScreenState extends State<LocalizacoesScreen> {
  Future<List<Localizacao>>? _localizacoesFuture;

  @override
  void initState() {
    super.initState();
    _carregarLocalizacoes();
  }

  void _carregarLocalizacoes() {
    setState(() {
      _localizacoesFuture = DatabaseHelper.instance.listarLocalizacoes();
    });
  }

  void _navegarParaCadastro([Localizacao? localizacao]) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CadastroLocalizacaoScreen(localizacao: localizacao),
      ),
    );
    if (resultado == true) {
      _carregarLocalizacoes();
    }
  }

  void _excluir(int id) async {
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Deseja realmente excluir esta localização?'),
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
      await DatabaseHelper.instance.deletarLocalizacao(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Localização excluída com sucesso')),
      );
      _carregarLocalizacoes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Localizações",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18, color: Colors.white),
              label: const Text(
                'Adicionar',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onPressed: () => _navegarParaCadastro(),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Localizacao>>(
        future: _localizacoesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmptyState(
                      icon: Icons.location_off,
                      title: 'Nenhuma localização cadastrada',
                      buttonText: 'Adicionar primeira localização',
                      onPressed: () => _navegarParaCadastro(),
                    ),
                  ],
                ),
              ),
            );
          }

          final localizacoes = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: localizacoes.length,
            itemBuilder: (context, index) {
              final loc = localizacoes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.green),
                  title: Text(
                    loc.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: loc.endereco.isNotEmpty ? Text(loc.endereco) : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Editar',
                        onPressed: () => _navegarParaCadastro(loc),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Excluir',
                        onPressed: () => _excluir(loc.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
