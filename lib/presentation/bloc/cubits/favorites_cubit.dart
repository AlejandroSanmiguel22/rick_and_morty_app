import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesCubit extends Cubit<List<Map<String, dynamic>>> {
  FavoritesCubit() : super([]);

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList("favorites") ?? [];
    emit(favorites.map((item) => jsonDecode(item) as Map<String, dynamic>).toList());
  }

  Future<void> toggleFavorite(Map<String, dynamic> character) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList("favorites") ?? [];
    bool isFavorite = favorites.any((item) => jsonDecode(item)["id"] == character["id"]);

    if (isFavorite) {
      favorites.removeWhere((item) => jsonDecode(item)["id"] == character["id"]);
    } else {
      favorites.add(jsonEncode(character));
    }

    await prefs.setStringList("favorites", favorites);
    loadFavorites(); // Recarga la lista de favoritos
  }

  bool isFavorite(int characterId) {
    return state.any((character) => character["id"] == characterId);
  }
}
