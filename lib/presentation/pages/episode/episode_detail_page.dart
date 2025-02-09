import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/domain/entities/character_entity.dart';
import 'package:rick_and_morty/domain/entities/episode_entity.dart';
import 'package:rick_and_morty/domain/repositories/resident_repository.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/residents/resident_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/residents/resident_state.dart';
import 'package:rick_and_morty/presentation/pages/character/character_detail_page.dart';
import 'package:rick_and_morty/presentation/widgets/custom_detail_card.dart';
import 'package:rick_and_morty/presentation/widgets/custom_grid.dart';

class EpisodeDetailPage extends StatelessWidget {
  final EpisodeEntity episode;

  const EpisodeDetailPage({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          episode.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDetailCard(
              details: [
                {
                  "icon": Icons.movie,
                  "label": "Episode",
                  "value": episode.episode,
                },
                {
                  "icon": Icons.calendar_today,
                  "label": "Air Date",
                  "value": episode.airDate,
                },
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: const Text(
                "Characters",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocProvider(
                create: (context) => ResidentCubit(
                  residentRepository: GetIt.I<ResidentRepository>(),
                )..fetchResidents(episode.characters),
                child: BlocBuilder<ResidentCubit, ResidentState>(
                  builder: (context, state) {
                    if (state is ResidentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ResidentError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is ResidentsLoaded) {
                      return SingleChildScrollView(
                        child: CustomGrid<CharacterEntity>(
                          items: state.residents,
                          getTitle: (character) => character.name,
                          getSubtitle: (character) => character.species,
                          getImageUrl: (character) => character.image,
                          onTap: (character) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CharacterDetailPage(character: character),
                              ),
                            );
                          },
                          aspectRatio:
                              0.8, 
                        ),
                      );
                    }
                    return const Center(
                      child: Text("No characters available."),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
