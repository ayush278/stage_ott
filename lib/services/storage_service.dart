import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites')?.map(int.parse).toList() ?? [];
  }

  static Future<void> saveFavorites(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorites',
      ids.map((e) => e.toString()).toList(),
    );
  }

  static Future<bool> getShowFavoritesOnly() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showFavoritesOnly') ?? false;
  }

  static Future<void> setShowFavoritesOnly(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showFavoritesOnly', value);
  }
}
