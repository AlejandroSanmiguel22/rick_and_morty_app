import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/domain/entities/character_entity.dart';
import 'package:rick_and_morty/domain/entities/location_entity.dart';
import 'package:rick_and_morty/domain/repositories/resident_repository.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/locations/location_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/locations/location_state.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/residents/resident_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/residents/resident_state.dart';
import 'package:rick_and_morty/presentation/pages/character/character_detail_page.dart';

class LocationDetailPage extends StatelessWidget {
  final LocationEntity location;

  const LocationDetailPage({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(location.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tipo: ${location.type}",
                style: const TextStyle(fontSize: 18)),
            Text("Dimensión: ${location.dimension}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text("Residentes:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: location.residents.length,
                itemBuilder: (context, index) {
                  return BlocProvider(
                    create: (context) => ResidentCubit(
                      residentRepository: GetIt.I<ResidentRepository>(),
                    )..fetchResident(location.residents[index]),
                    child: BlocBuilder<ResidentCubit, ResidentState>(
                      builder: (context, state) {
                        if (state is ResidentLoading) {
                          return const ListTile(title: Text("Cargando..."));
                        } else if (state is ResidentError) {
                          return ListTile(title: Text(state.message));
                        } else if (state is ResidentLoaded) {
                          final resident = state.resident;
                          return ListTile(
                            leading: CircleAvatar(
                                backgroundImage: NetworkImage(resident.image)),
                            title: Text(resident.name),
                            subtitle: Text(resident.species),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CharacterDetailPage(character: resident),
                                ),
                              );
                            },
                          );
                        }
                        return const ListTile(title: Text("No disponible"));
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
