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
            return ListView.builder(
              itemCount: state.episodes.length,
              itemBuilder: (context, index) {
                final episode = state.episodes[index];
                return ListTile(
                  title: Text("${episode.episode} - ${episode.name}"),
                  subtitle: Text("Air date: ${episode.airDate}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EpisodeDetailPage(episode: episode),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is EpisodeError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text("No episodes available."));
        },
      ),
    );
  }
}
