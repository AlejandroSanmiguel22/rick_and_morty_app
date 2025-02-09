import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/episode_name_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/episode_name_state.dart';
import 'package:rick_and_morty/presentation/widgets/custom_detail_card.dart';
import 'package:rick_and_morty/presentation/widgets/custom_grid.dart';
import '../../../domain/entities/character_entity.dart';
import '../../bloc/cubits/favorites_cubit.dart';

class CharacterDetailPage extends StatelessWidget {
  final CharacterEntity character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<EpisodeNameCubit>(context)
        .fetchEpisodesName(character.episode);

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          BlocBuilder<FavoritesCubit, List<Map<String, dynamic>>>(
            builder: (context, favorites) {
              bool isFavorite =
                  favorites.any((fav) => fav["id"] == character.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.117),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(character.image,
                    width: 220, height: 220, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            CustomDetailCard(
              details: [
                {"icon": Icons.person, "label": "Species", "value": character.species},
                {"icon": Icons.favorite, "label": "Status", "value": character.status},
                {"icon": Icons.male, "label": "Gender", "value": character.gender},
                {"icon": Icons.public, "label": "Origin", "value": character.origin},
                {"icon": Icons.place, "label": "Location", "value": character.location},
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Episode Appearances",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            BlocBuilder<EpisodeNameCubit, EpisodeNameState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: state is EpisodeNameLoading
                      ? const CircularProgressIndicator()
                      : state is EpisodeLoadedName
                          ? CustomGrid<String>(
                              items: state.episodeNames,
                              getTitle: (episode) => episode,
                              icon: Icons.tv,
                              aspectRatio: 1.5,
                              onTap: (episode) {
                               
                              },
                            )
                          : state is EpisodeNameError
                              ? Text(state.message, style: const TextStyle(color: Colors.red))
                              : const SizedBox.shrink(),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
