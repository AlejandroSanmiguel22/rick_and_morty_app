import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/episode_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/episode_state.dart';
import 'package:rick_and_morty/presentation/pages/episode/episode_detail_page.dart';

class EpisodeListPage extends StatelessWidget {
  const EpisodeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EpisodeCubit, EpisodeState>(
        builder: (context, state) {
          if (state is EpisodeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EpisodeLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListView.separated(
                itemCount: state.episodes.length,
                separatorBuilder: (_, __) => const Divider(
                    height: 1, thickness: 0.8),
                itemBuilder: (context, index) {
                  final episode = state.episodes[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8),
                    leading: const Icon(Icons.tv,
                        size: 30,
                        color: Colors.blueAccent), 
                    title: Text(
                      "${episode.episode} - ${episode.name}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Air date: ${episode.airDate}",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EpisodeDetailPage(episode: episode),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10)), 
                  );
                },
              ),
            );
          } else if (state is EpisodeError) {
            return Center(
              child: Text(
                state.message,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }

          return const Center(
            child: Text("No episodes available.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }
}
