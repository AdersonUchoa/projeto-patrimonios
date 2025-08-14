import 'package:flutter/material.dart';
import 'package:patrimonios/screens/cadastro_patrimonio_screen.dart';
import 'package:patrimonios/widgets/empty_state.dart';

class PatrimonioScreen extends StatelessWidget {
  const PatrimonioScreen({super.key});

    void _abrirCadastroPatrimonio(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroPatrimonioScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de Patrimônio', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
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
                      Text(
                        'Valor Total do Patrimônio',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'R\$ 0,00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.inventory_2_outlined, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text('0 itens', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.attach_money, color: Colors.white, size: 40),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Text('Todas as categorias', style: TextStyle(color: Colors.grey[600])),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
              onPressed: () => _abrirCadastroPatrimonio(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Row(
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
          ),
          
          Expanded(
            child: EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Nenhum item de patrimônio cadastrado',
              buttonText: 'Adicionar primeiro item',
              onPressed: () => _abrirCadastroPatrimonio(context),
            ),
          ),
        ],
      ),
    );
  }
}