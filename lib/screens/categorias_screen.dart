import 'package:flutter/material.dart';
import 'package:patrimonios/db/database_helper.dart';
import 'package:patrimonios/models/categoria.dart';
import 'package:patrimonios/screens/cadastro_categoria_screen.dart';
import 'package:patrimonios/widgets/empty_state.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  Future<List<Categoria>>? _categoriasFuture;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
  }

  void _carregarCategorias() {
    setState(() {
      _categoriasFuture = DatabaseHelper.instance.listarCategorias();
    });
  }

  void _abrirCadastroCategoria([Categoria? categoria]) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CadastroCategoriaScreen(categoria: categoria),
      ),
    );
    if (resultado == true) {
      _carregarCategorias();
    }
  }

  void _excluir(int id) async {
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Deseja realmente excluir esta categoria?'),
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
      try {
        await DatabaseHelper.instance.deletarCategoria(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria excluída com sucesso')),
        );
        _carregarCategorias();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir: $e')),
        );
      }
    }
  }

  Icon _iconePorTipo(String tipo) {
    switch (tipo) {
      case 'Móveis':
        return const Icon(Icons.chair, color: Colors.brown);
      case 'Eletrônicos':
        return const Icon(Icons.electrical_services, color: Colors.blue);
      case 'Informática':
        return const Icon(Icons.computer, color: Colors.indigo);
      case 'Veículos':
        return const Icon(Icons.directions_car, color: Colors.red);
      case 'Equipamentos':
        return const Icon(Icons.build_circle, color: Colors.orange);
      case 'Imóveis':
        return const Icon(Icons.home, color: Colors.green);
      case 'Ferramentas':
        return const Icon(Icons.handyman, color: Colors.grey);
      case 'Livros':
        return const Icon(Icons.menu_book, color: Colors.purple);
      case 'Máquinas':
        return const Icon(Icons.precision_manufacturing, color: Colors.teal);
      case 'Outros':
        return const Icon(Icons.inventory, color: Colors.blueGrey);
      default:
        return const Icon(Icons.folder, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categorias',
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
              onPressed: () => _abrirCadastroCategoria(),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Categoria>>(
        future: _categoriasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text("Erro: ${snapshot.error}"),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmptyState(
                      icon: Icons.folder_outlined,
                      title: 'Nenhuma categoria cadastrada',
                      buttonText: 'Criar primeira categoria',
                      onPressed: () => _abrirCadastroCategoria(),
                    ),
                  ],
                ),
              ),
            );
          }

          final categorias = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final cat = categorias[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getColorForType(cat.tipo).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _iconePorTipo(cat.tipo),
                  ),
                  title: Text(
                    cat.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Tipo: ${cat.tipo}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      if (cat.observacoes.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          cat.observacoes,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Editar',
                        onPressed: () => _abrirCadastroCategoria(cat),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Excluir',
                        onPressed: () => _excluir(cat.id!),
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

  Color _getColorForType(String tipo) {
    switch (tipo) {
      case 'Móveis':
        return Colors.brown;
      case 'Eletrônicos':
        return Colors.blue;
      case 'Informática':
        return Colors.indigo;
      case 'Veículos':
        return Colors.red;
      case 'Equipamentos':
        return Colors.orange;
      case 'Imóveis':
        return Colors.green;
      case 'Ferramentas':
        return Colors.grey;
      case 'Livros':
        return Colors.purple;
      case 'Máquinas':
        return Colors.teal;
      case 'Outros':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }
}