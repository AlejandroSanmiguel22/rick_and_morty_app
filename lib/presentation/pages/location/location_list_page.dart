import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/locations/location_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/locations/location_state.dart';
import 'package:rick_and_morty/presentation/pages/location/location_detail_page.dart';

class LocationListPage extends StatelessWidget {
  const LocationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LocationLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListView.separated(
                itemCount: state.locations.length,
                separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.8),
                itemBuilder: (context, index) {
                  final location = state.locations[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    leading: const Icon(Icons.location_on, size: 30, color: Colors.blue), 
                    title: Text(
                      location.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${location.type} - ${location.dimension}",
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationDetailPage(location: location),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), 
                  );
                },
              ),
            );
          } else if (state is LocationError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }
          return const Center(
            child: Text("No hay ubicaciones disponibles.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }
}