import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/data/datasources/remote/episode_remote_datasource.dart';
import 'package:rick_and_morty/data/datasources/remote/location_remote_datasource.dart';
import 'package:rick_and_morty/data/datasources/remote/resident_remote_datasource.dart';
import 'package:rick_and_morty/data/repositories/episode_repository_impl.dart';
import 'package:rick_and_morty/data/repositories/location_repository_impl.dart';
import 'package:rick_and_morty/data/repositories/resident_repository_impl.dart';
import 'package:rick_and_morty/domain/repositories/character_repository.dart';
import 'package:rick_and_morty/domain/repositories/episode_repository.dart';
import 'package:rick_and_morty/domain/repositories/location_repository.dart';
import 'package:rick_and_morty/domain/repositories/resident_repository.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/characters/character_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/characters/search_characters_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/episode_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/episode_name_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/favorites_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/locations/location_cubit.dart';
import 'package:rick_and_morty/data/repositories/character_repository_impl.dart';
import 'package:rick_and_morty/data/datasources/remote/character_remote_datasource.dart';
import 'package:rick_and_morty/core/network/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/locations/search_locations_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/residents/resident_cubit.dart';
import 'package:rick_and_morty/presentation/pages/home_page.dart';

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

  final locationRemoteDataSource = LocationRemoteDataSource(apiClient.dio);
  final locationRepository =
      LocationRepositoryImpl(remoteDataSource: locationRemoteDataSource);
  GetIt.I.registerSingleton<LocationRepository>(locationRepository);

  final residentRemoteDataSource = ResidentRemoteDataSource(apiClient.dio);
  final residentRepository =
      ResidentRepositoryImpl(remoteDataSource: residentRemoteDataSource);
  GetIt.I.registerSingleton<ResidentRepository>(residentRepository);

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CharacterCubit(repository: GetIt.I<CharacterRepository>())
                ..fetchCharacters(),
        ),
        BlocProvider(
          create: (context) => EpisodeCubit(
            episodeRepository: GetIt.I<EpisodeRepository>(),
          )..fetchEpisodes()
        ),
        BlocProvider(
          create: (context) => EpisodeNameCubit(
            episodeRepository: GetIt.I<EpisodeRepository>(),
          )
        ),
        BlocProvider(
          create: (context) => FavoritesCubit()..loadFavorites(),
        ),
        BlocProvider(
          create: (context) =>
              LocationCubit(locationRepository: GetIt.I<LocationRepository>())
                ..fetchLocations(),
        ),
        BlocProvider(
          create: (context) =>
              ResidentCubit(residentRepository: GetIt.I<ResidentRepository>()),
        ),

        BlocProvider(
          create: (context) => SearchCharactersCubit(
            GetIt.I<CharacterRepository>(),
          ),
        ),

         BlocProvider(
          create: (context) => SearchLocationsCubit(
            GetIt.I<LocationRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rick and Morty',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true),
        home: const HomePage(),
      ),
    );
  }
}
