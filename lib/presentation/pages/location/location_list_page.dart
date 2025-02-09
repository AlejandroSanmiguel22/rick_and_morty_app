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
            return ListView.builder(
              itemCount: state.locations.length,
              itemBuilder: (context, index) {
                final location = state.locations[index];
                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(location.name),
                  subtitle: Text("${location.type} - ${location.dimension}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationDetailPage(location: location),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is LocationError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No hay ubicaciones disponibles."));
        },
      ),
    );
  }
}
