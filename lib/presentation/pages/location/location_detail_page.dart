import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/domain/entities/character_entity.dart';
import 'package:rick_and_morty/domain/entities/location_entity.dart';
import 'package:rick_and_morty/domain/repositories/resident_repository.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/residents/resident_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/residents/resident_state.dart';
import 'package:rick_and_morty/presentation/pages/character/character_detail_page.dart';
import 'package:rick_and_morty/presentation/widgets/custom_detail_card.dart';
import 'package:rick_and_morty/presentation/widgets/custom_grid.dart';

class LocationDetailPage extends StatelessWidget {
  final LocationEntity location;

  const LocationDetailPage({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomDetailCard(
              details: [
                {
                  "icon": Icons.location_on,
                  "label": "Type",
                  "value": location.type,
                },
                {
                  "icon": Icons.public,
                  "label": "Dimension",
                  "value": location.dimension,
                },
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Residents",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            location.residents.isNotEmpty
                ? BlocProvider(
                    create: (context) => ResidentCubit(
                      residentRepository: GetIt.I<ResidentRepository>(),
                    )..fetchResidents(location.residents),
                    child: BlocBuilder<ResidentCubit, ResidentState>(
                      builder: (context, state) {
                        if (state is ResidentLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is ResidentError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (state is ResidentsLoaded) {
                          return CustomGrid<CharacterEntity>(
                            items: state.residents,
                            getTitle: (resident) => resident.name,
                            getSubtitle: (resident) => resident.species,
                            getImageUrl: (resident) => resident.image,
                            onTap: (resident) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CharacterDetailPage(character: resident),
                                ),
                              );
                            },
                            aspectRatio: 0.7,
                          );
                        }
                        return const Center(
                          child: Text("No residents available."),
                        );
                      },
                    ),
                  )
                : const Text("No residents available.",
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
