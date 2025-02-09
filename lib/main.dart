import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/data/datasources/remote/episode_remote_datasource.dart';
import 'package:rick_and_morty/data/repositories/episode_repository_impl.dart';
import 'package:rick_and_morty/domain/repositories/character_repository.dart';
import 'package:rick_and_morty/domain/repositories/episode_repository.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/character_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episode_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/favorites_cubit.dart';
import 'package:rick_and_morty/presentation/pages/character_list_page.dart';
import 'package:rick_and_morty/data/repositories/character_repository_impl.dart';
import 'package:rick_and_morty/data/datasources/remote/character_remote_datasource.dart';
import 'package:rick_and_morty/core/network/api_client.dart';
import 'package:get_it/get_it.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

void setupLocator() {
  final apiClient = ApiClient();

  final characterRemoteDataSource = CharacterRemoteDataSource(apiClient);
  final characterRepository =
      CharacterRepositoryImpl(remoteDataSource: characterRemoteDataSource);
  GetIt.I.registerSingleton<CharacterRepository>(characterRepository);

  final episodeRemoteDataSource = EpisodeRemoteDataSource(apiClient.dio);
  final episodeRepository =
      EpisodeRepositoryImpl(remoteDataSource: episodeRemoteDataSource);
  GetIt.I.registerSingleton<EpisodeRepository>(episodeRepository);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CharacterCubit(
            repository: GetIt.I<CharacterRepository>(),
          )..fetchCharacters(),
        ),
        BlocProvider(
          create: (context) => EpisodeCubit(
            episodeRepository: GetIt.I<EpisodeRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => FavoritesCubit()..loadFavorites(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rick and Morty',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CharacterListPage(),
      ),
    );
  }
}
