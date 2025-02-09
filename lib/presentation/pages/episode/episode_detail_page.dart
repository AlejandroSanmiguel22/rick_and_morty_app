import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/domain/entities/episode_entity.dart';
import 'package:rick_and_morty/domain/repositories/resident_repository.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/residents/resident_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/residents/resident_state.dart';
import 'package:rick_and_morty/presentation/pages/character/character_detail_page.dart';

class EpisodeDetailPage extends StatelessWidget {
  final EpisodeEntity episode;

  const EpisodeDetailPage({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(episode.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Episode: ${episode.episode}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Air Date: ${episode.airDate}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text("Characters:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: episode.characters.length,
                itemBuilder: (context, index) {
                  return BlocProvider(
                    create: (context) => ResidentCubit(
                      residentRepository: GetIt.I<ResidentRepository>(),
                    )..fetchResident(episode.characters[index]),
                    child: BlocBuilder<ResidentCubit, ResidentState>(
                      builder: (context, state) {
                        if (state is ResidentLoading) {
                          return const ListTile(title: Text("Loading..."));
                        } else if (state is ResidentError) {
                          return ListTile(title: Text(state.message));
                        } else if (state is ResidentLoaded) {
                          final character = state.resident;
                          return ListTile(
                            leading: CircleAvatar(backgroundImage: NetworkImage(character.image)),
                            title: Text(character.name),
                            subtitle: Text(character.species),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CharacterDetailPage(character: character),
                                ),
                              );
                            },
                          );
                        }
                        return const ListTile(title: Text("No data available"));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
