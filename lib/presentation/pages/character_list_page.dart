import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/character_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/character_state.dart';
import 'package:rick_and_morty/presentation/pages/character_detail_page.dart';
import 'favorites_page.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty Characters"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              // Navegar a la pantalla de favoritos
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CharacterCubit, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharacterLoaded) {
            return ListView.builder(
              itemCount: state.characters.length,
              itemBuilder: (context, index) {
                final character = state.characters[index];
                return ListTile(
                  leading: Image.network(character.image),
                  title: Text(character.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(character.species),
                      Text(character.status),
                      Text(character.origin),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CharacterDetailPage(character: character),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is CharacterError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }
}
