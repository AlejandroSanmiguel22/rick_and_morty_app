import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/favorites_cubit.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favoritos")),
      body: BlocBuilder<FavoritesCubit, List<Map<String, dynamic>>>(
        builder: (context, favorites) {
          if (favorites.isEmpty) {
            return const Center(child: Text("No hay favoritos aún."));
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return ListTile(
                leading: Image.network(favorite["image"]),
                title: Text(favorite["name"]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    BlocProvider.of<FavoritesCubit>(context)
                        .toggleFavorite(favorite);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
