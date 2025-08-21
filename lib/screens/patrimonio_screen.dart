import 'package:flutter/material.dart';
import 'package:patrimonios/db/database_helper.dart';
import 'package:patrimonios/models/categoria.dart';
import 'package:patrimonios/models/patrimonio.dart';
import 'package:patrimonios/screens/cadastro_patrimonio_screen.dart';
import 'package:patrimonios/widgets/empty_state.dart';
import 'package:intl/intl.dart';

class PatrimonioScreen extends StatefulWidget {
  const PatrimonioScreen({super.key});

  @override
  State<PatrimonioScreen> createState() => _PatrimonioScreenState();
}

class _PatrimonioScreenState extends State<PatrimonioScreen> {
  Future<List<Patrimonio>>? _patrimoniosFuture;
  Future<List<Categoria>>? _categoriasFuture;
  Future<double>? _valorTotalFuture;
  Future<int>? _totalItensFuture;
  
  int? _categoriaSelecionada;
  String _nomeCategoriaSelecionada = 'Todas as categorias';

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    setState(() {
      _patrimoniosFuture = DatabaseHelper.instance.listarPatrimonios(
        categoriaId: _categoriaSelecionada,
      );
      _categoriasFuture = DatabaseHelper.instance.listarCategorias();
      _valorTotalFuture = DatabaseHelper.instance.calcularValorTotalPatrimonio();
      _totalItensFuture = DatabaseHelper.instance.contarTotalPatrimonios();
    });
  }

  void _abrirCadastroPatrimonio([Patrimonio? patrimonio]) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroPatrimonioScreen(patrimonio: patrimonio),
      ),
    );
    if (resultado == true) {
      _carregarDados();
    }
  }

  void _excluir(int id) async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Deseja realmente excluir este item do patrimônio?'),
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
        await DatabaseHelper.instance.deletarPatrimonio(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item excluído com sucesso')),
        );
        _carregarDados();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir: $e')),
        );
      }
    }
  }

  void _mostrarFiltroCategoria() async {
    final categorias = await _categoriasFuture;
    if (categorias == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Indicador de arrastar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Filtrar por categoria',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    ListTile(
                      title: const Text('Todas as categorias'),
                      leading: Radio<int?>(
                        value: null,
                        groupValue: _categoriaSelecionada,
                        onChanged: (value) {
                          setState(() {
                            _categoriaSelecionada = null;
                            _nomeCategoriaSelecionada = 'Todas as categorias';
                          });
                          _carregarDados();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    ...categorias.map((categoria) => ListTile(
                      title: Text(categoria.nome),
                      leading: Radio<int?>(
                        value: categoria.id,
                        groupValue: _categoriaSelecionada,
                        onChanged: (value) {
                          setState(() {
                            _categoriaSelecionada = categoria.id;
                            _nomeCategoriaSelecionada = categoria.nome;
                          });
                          _carregarDados();
                          Navigator.pop(context);
                        },
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatarMoeda(double valor) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(valor);
  }

  String _formatarData(String data) {
    try {
      final DateTime dateTime = DateTime.parse(data);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return data;
    }
  }

  Widget _buildResumoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Valor Total do Patrimônio',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                FutureBuilder<double>(
                  future: _valorTotalFuture,
                  builder: (context, snapshot) {
                    final valor = snapshot.data ?? 0.0;
                    return Text(
                      _formatarMoeda(valor),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    FutureBuilder<int>(
                      future: _totalItensFuture,
                      builder: (context, snapshot) {
                        final total = snapshot.data ?? 0;
                        return Text(
                          '$total itens',
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.attach_money, color: Colors.white, size: 40),
        ],
      ),
    );
  }

  Widget _buildFiltrosEBotoes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _mostrarFiltroCategoria,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Text(
                      _nomeCategoriaSelecionada,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => _abrirCadastroPatrimonio(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 4),
                Text('Adicionar', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaPatrimonios() {
    return Expanded(
      child: FutureBuilder<List<Patrimonio>>(
        future: _patrimoniosFuture,
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
            return Padding(
              padding: const EdgeInsets.all(24),
              child: EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'Nenhum item de patrimônio cadastrado',
                buttonText: 'Adicionar primeiro item',
                onPressed: () => _abrirCadastroPatrimonio(),
              ),
            );
          }

          final patrimonios = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: patrimonios.length,
            itemBuilder: (context, index) {
              final patrimonio = patrimonios[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.inventory_2, color: Colors.blue),
                  ),
                  title: Text(
                    patrimonio.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Código: ${patrimonio.codigo}'),
                      Text(
                        'Valor: ${_formatarMoeda(patrimonio.valor)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (patrimonio.nomeCategoria != null)
                        Text('Categoria: ${patrimonio.nomeCategoria}'),
                      Text('Data: ${_formatarData(patrimonio.dataAquisicao)}'),
                      if (patrimonio.nomeLocalizacao != null)
                        Text('Local: ${patrimonio.nomeLocalizacao}'),
                      if (patrimonio.nomePessoa != null)
                        Text('Responsável: ${patrimonio.nomePessoa}'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Editar',
                        onPressed: () => _abrirCadastroPatrimonio(patrimonio),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Excluir',
                        onPressed: () => _excluir(patrimonio.id!),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestão de Patrimônio',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildResumoCard(),
          _buildFiltrosEBotoes(),
          const SizedBox(height: 16),
          _buildListaPatrimonios(),
        ],
      ),
    );
  }
}