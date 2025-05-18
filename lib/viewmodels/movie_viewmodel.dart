import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class MovieViewModel extends ChangeNotifier {
  List<Movie> _movies = [];
  List<int> _favorites = [];
  bool _isLoading = false;
  String _error = '';
  bool _isOffline = false;
  bool _showFavoritesOnly = false;

  List<Movie> get movies => _movies;
  List<int> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isOffline => _isOffline;
  bool get showFavoritesOnly => _showFavoritesOnly;

  Future<void> initializeApp() async {
    await checkConnectivity();
    _favorites = await StorageService.getFavorites();
    _showFavoritesOnly = await StorageService.getShowFavoritesOnly();
    if (!_isOffline) {
      await loadMovies();
    }
    notifyListeners();
  }

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _isOffline = connectivityResult == ConnectivityResult.none;
  }

  Future<void> loadMovies() async {
    _isLoading = true;
    notifyListeners();
    try {
      _movies = await ApiService.fetchMovies();
      _error = '';
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  bool isFavorite(int id) => _favorites.contains(id);

  void toggleFavorite(int id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    StorageService.saveFavorites(_favorites);
    notifyListeners();
  }

  void toggleShowFavoritesOnly() {
    _showFavoritesOnly = !_showFavoritesOnly;
    StorageService.setShowFavoritesOnly(_showFavoritesOnly);
    notifyListeners();
  }

  List<Movie> get favoriteMovies =>
      _movies.where((m) => _favorites.contains(m.id)).toList();

  List<Movie> search(String query) {
    return _movies
        .where((m) => m.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
