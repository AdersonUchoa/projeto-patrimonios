import 'package:flutter/material.dart';
import 'package:patrimonios/widgets/empty_state.dart';

class CategoriasScreen extends StatelessWidget {
  const CategoriasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de Patrimônio', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text('Nova Categoria', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Categorias',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: EmptyState(
              icon: Icons.folder_outlined,
              title: 'Nenhuma categoria cadastrada',
              buttonText: 'Criar primeira categoria',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}