import 'package:flutter/material.dart';
import 'package:rick_and_morty/presentation/pages/character/character_list_page.dart';
import 'package:rick_and_morty/presentation/pages/favorites_page.dart';
import 'package:rick_and_morty/presentation/pages/location/location_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 0 = Personajes, 1 = Ubicaciones, 2 = Episodios

  final List<Widget> _pages = [
    CharacterListPage(),
    LocationListPage(),
    //EpisodeListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty Explorer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMenuButtons(),
          Expanded(
              child: _pages[_selectedIndex]), 
        ],
      ),
    );
  }

  Widget _buildMenuButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOption("Personajes", 0),
          _buildOption("Ubicaciones", 1),
          _buildOption("Episodios", 2),
        ],
      ),
    );
  }

  Widget _buildOption(String title, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedIndex == index ? Colors.blue : Colors.grey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(title),
    );
  }
}
