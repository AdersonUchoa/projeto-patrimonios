import 'package:flutter/material.dart';
import 'package:patrimonios/screens/categorias_screen.dart';
import 'package:patrimonios/screens/localizacoes_screen.dart';
import 'package:patrimonios/screens/patrimonio_screen.dart';
import 'package:patrimonios/screens/pessoas_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    PatrimonioScreen(),
    CategoriasScreen(),
    PessoasScreen(),
    LocalizacoesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Patrimônio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Pessoas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Localizações',
          ),
        ],
      ),
    );
  }
}