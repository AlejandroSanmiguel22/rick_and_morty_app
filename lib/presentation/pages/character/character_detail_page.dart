import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/episode_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/episode_name_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/episode_name_state.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/episode_state.dart';
import '../../../domain/entities/character_entity.dart';
import '../../bloc/cubits/favorites_cubit.dart';

class CharacterDetailPage extends StatelessWidget {
  final CharacterEntity character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {

    BlocProvider.of<EpisodeNameCubit>(context).fetchEpisodesName(character.episode);

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        actions: [
          BlocBuilder<FavoritesCubit, List<Map<String, dynamic>>>(
            builder: (context, favorites) {
              bool isFavorite =
                  favorites.any((fav) => fav["id"] == character.id);
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red),
                onPressed: () {
                  BlocProvider.of<FavoritesCubit>(context).toggleFavorite({
                    "id": character.id,
                    "name": character.name,
                    "image": character.image
                  });
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(character.image, width: 200),
            ),
            const SizedBox(height: 20),
            Text(character.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Species: ${character.species}"),
            Text("Status: ${character.status}"),
            Text("Gender: ${character.gender}"),
            Text("Origin: ${character.origin}"),
            Text("Location: ${character.location}"),
            const SizedBox(height: 20),
            const Text(
              "Episode appearances:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            BlocBuilder<EpisodeNameCubit, EpisodeNameState>(
              builder: (context, state) {
                if (state is EpisodeNameLoading) {
                  return const CircularProgressIndicator();
                } else if (state is EpisodeLoadedName) {
                  return Column(
                    children: state.episodeNames
                        .map((ep) =>
                            Text(ep, style: const TextStyle(fontSize: 16)))
                        .toList(),
                  );
                } else if (state is EpisodeNameError) {
                  return Text(state.message);
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
