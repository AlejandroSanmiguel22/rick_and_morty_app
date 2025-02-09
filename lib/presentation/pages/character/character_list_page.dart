import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/characters/character_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/characters/character_state.dart';
import 'package:rick_and_morty/presentation/pages/character/character_detail_page.dart';
import 'package:rick_and_morty/presentation/widgets/custom_card.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CharacterCubit, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharacterLoaded) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8, 
                ),
                itemCount: state.characters.length,
                itemBuilder: (context, index) {
                  final character = state.characters[index];
                  return CustomCard(
                    title: character.name,
                    subtitle: "${character.species} - ${character.status}",
                    imageUrl: character.image,
                    extraInfo: [
                      "Origin: ${character.origin}",
                      "Gender: ${character.gender}"
                    ],
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
              ),
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