import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/favorites_cubit.dart';
import 'package:rick_and_morty/presentation/widgets/custom_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<FavoritesCubit, List<Map<String, dynamic>>>(
          builder: (context, favorites) {
            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_border,
                        size: 100, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text(
                      "No favorites yet!",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            }

            return GridView.builder(
              itemCount: favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final favorite = favorites[index];

                return CustomCard(
                  title: favorite["name"],
                  imageUrl: favorite["image"],
                  width: 180, // 🔥 Puedes definir el tamaño
                  height:
                      310, // 🔥 O dejarlo con el valor predeterminado (160.0)
                  onDelete: () {
                    BlocProvider.of<FavoritesCubit>(context)
                        .toggleFavorite(favorite);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
