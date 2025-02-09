import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String lastSearchKey = "last_search_query";

  Future<void> saveLastSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastSearchKey, query);
  }

  Future<String?> getLastSearch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastSearchKey);
  }
}
